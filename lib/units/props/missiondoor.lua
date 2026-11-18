local IDS_BASE = Idstring("base")
local IDS_MISSION_DOOR_DEVICE = Idstring("mission_door_device")

MissionDoor = MissionDoor or class(UnitBase)
MissionDoor.C4_EXPLODE_TIME = 5
MissionDoor.PLACED_COUNTER_MAP = {
	c4 = function(self)
		self:_initiate_c4_sequence()
	end,
	key = function(self, device_type)
		for _, unit_data in ipairs(self._devices[device_type].units) do
			self:device_completed(device_type)
		end
	end
}
MissionDoor.PLACED_COUNTER_MAP.ecm = MissionDoor.PLACED_COUNTER_MAP.key
MissionDoor.COMPLETED_COUNTER_MAP = {
	default = {
		sequence_name = "open_door"
	},
	drill = {
		sequence_name = "open_door"
	},
	c4 = {
		sequence_name = "explode_door",
		pre_sequence_fn = function(self)
			if not Network:is_server() then
				return
			end

			local base_ext = self._unit:base()

			if base_ext then
				base_ext.c4 = true
			end

			local groupai_state = managers.groupai:state()
			local alert_filter = groupai_state:get_unit_type_filter("combatant")
			local alert_event = {
				"explosion",
				self._unit:position(),
				tweak_data.weapon.trip_mines.alert_radius,
				alert_filter,
				self._unit
			}

			groupai_state:propagate_alert(alert_event)
		end
	},
	key = {
		sequence_name = "open_door_keycard"
	},
	ecm = {
		sequence_name = "open_door_ecm"
	}
}

-- Lines 57-64
function MissionDoor:init(unit)
	MissionDoor.super.init(self, unit, false)

	self._unit = unit
	self._devices = {}
	self._powered = true
end

-- Lines 68-72
function MissionDoor:update(unit, t, dt)
	if self._explode_t and t > self._explode_t then
		self:_c4_sequence_done()
	end
end

-- Lines 76-149
function MissionDoor:activate()
	if not Network:is_server() then
		return
	end

	if self._active then
		Application:error("[MissionDoor] activate() - already active", self._unit)

		return
	end

	self._active = true

	local devices_data = tweak_data.mission_door[self.tweak_data].devices

	for device_type, device_data in pairs(devices_data) do
		local amount = #device_data
		local device_units = {}

		self._devices[device_type] = {
			completed = false,
			completed_counter = 0,
			placed = false,
			placed_counter = 0,
			units = device_units,
			amount = amount
		}

		for _, unit_data in ipairs(device_data) do
			local a_obj = self._unit:get_object(Idstring(unit_data.align))
			local position = a_obj:position()
			local rotation = a_obj:rotation()
			local unit = safe_spawn_unit(unit_data.unit, position, rotation)

			unit:mission_door_device():set_parent_data(self._unit, device_type)

			local timer_gui_ext = unit:timer_gui()

			if unit_data.can_jam ~= nil then
				timer_gui_ext:set_can_jam(unit_data.can_jam)
			end

			if unit_data.timer then
				timer_gui_ext:set_override_timer(unit_data.timer)
			end

			MissionDoor.run_mission_door_device_sequence(unit, "activate")
			managers.network:send_to_peers_synched("run_mission_door_device_sequence", unit, "activate")
			table.insert(device_units, {
				completed = false,
				placed = false,
				unit = unit
			})
		end
	end
end

-- Lines 153-167
function MissionDoor.run_mission_door_device_sequence(unit, sequence_name)
	local dmg_ext = unit:damage()

	if dmg_ext:has_sequence(sequence_name) then
		dmg_ext:run_sequence_simple(sequence_name)
	end
end

-- Lines 169-175
function MissionDoor:deactivate()
	self._active = nil

	self:_destroy_devices()
end

-- Lines 179-187
function MissionDoor.set_mission_door_device_powered(unit, powered, enabled_interaction)
	local dmg_ext = unit:damage()

	unit:timer_gui():set_powered(powered, enabled_interaction)
end

-- Lines 189-206
function MissionDoor:set_jammed(jammed)
	self._jammed = jammed

	local drills = self._devices.drill

	if not drills then
		return
	end

	local is_server = Network:is_server()

	for _, unit_data in ipairs(drills.units) do
		if unit_data.placed and alive(unit_data.unit) then
			unit_data.unit:timer_gui():set_jammed(jammed)

			if is_server then
				managers.network:send_to_peers_synched("set_mission_door_device_powered", unit_data.unit, jammed, false)
			end
		end
	end
end

-- Lines 209-226
function MissionDoor:set_powered(powered)
	self._powered = powered

	local drills = self._devices.drill

	if not drills then
		return
	end

	local is_server = Network:is_server()

	for _, unit_data in ipairs(drills.units) do
		if unit_data.placed and alive(unit_data.unit) then
			unit_data.unit:timer_gui():set_powered(powered)

			if is_server then
				managers.network:send_to_peers_synched("set_mission_door_device_powered", unit_data.unit, powered, false)
			end
		end
	end
end

-- Lines 230-245
function MissionDoor:set_on(state)
	local drills = self._devices.drill

	if not drills then
		return
	end

	local is_server = Network:is_server()

	for _, unit_data in ipairs(drills.units) do
		if unit_data.placed and alive(unit_data.unit) then
			unit_data.unit:timer_gui():set_powered(state, true)

			if is_server then
				managers.network:send_to_peers_synched("set_mission_door_device_powered", unit_data.unit, state, true)
			end
		end
	end
end

-- Lines 249-264
function MissionDoor:_get_device_unit_data(unit, device_type)
	if not self._devices[device_type] then
		return nil
	end

	for _, unit_data in ipairs(self._devices[device_type].units) do
		if unit_data.unit == unit then
			return unit_data
		end
	end

	return nil
end

-- Lines 266-283
function MissionDoor:device_placed(unit, device_type)
	local device_unit_data = self:_get_device_unit_data(unit, device_type)

	if not device_unit_data or device_unit_data.placed then
		return
	end

	self._devices[device_type].placed_counter = self._devices[device_type].placed_counter + 1
	device_unit_data.placed = true

	self:trigger_sequence(device_type .. "_placed")
	self:_check_placed_counter(device_type)
end

-- Lines 285-298
function MissionDoor:device_completed(device_type)
	local device_data = self._devices[device_type]

	if not device_data then
		return
	end

	device_data.completed = true
	device_data.completed_counter = device_data.completed_counter + 1

	self:trigger_sequence(device_type .. "_completed")
	self:_check_completed_counter(device_type)
end

-- Lines 300-302
function MissionDoor:device_jammed(device_type)
	self:trigger_sequence(device_type .. "_jammed")
end

-- Lines 304-306
function MissionDoor:device_resumed(device_type)
	self:trigger_sequence(device_type .. "_resumed")
end

-- Lines 310-321
function MissionDoor:_check_placed_amount_match(device_type)
	local device_data = self._devices[device_type]

	if not device_data then
		return false
	end

	return device_data.placed_counter == device_data.amount
end

-- Lines 323-334
function MissionDoor:_check_placed_all(device_type)
	local device_data = self._devices[device_type]

	if not device_data then
		return false
	end

	return device_data.completed_counter == device_data.amount
end

-- Lines 336-358
function MissionDoor:_check_placed_counter(device_type)
	if not self:_check_placed_amount_match(device_type) then
		return
	end

	self:trigger_sequence("all_" .. device_type .. "_placed")

	if not self:_check_placed_amount_match(device_type) then
		return
	end

	local fn = MissionDoor.PLACED_COUNTER_MAP[device_type]

	if fn then
		fn(self, device_type)
	end
end

-- Lines 360-383
function MissionDoor:_check_completed_counter(device_type)
	if not self:_check_placed_all(device_type) then
		return
	end

	self:_destroy_devices()
	self:trigger_sequence("door_opened")

	local data = MissionDoor.COMPLETED_COUNTER_MAP[device_type] or MissionDoor.COMPLETED_COUNTER_MAP.default

	if data.pre_sequence_fn then
		data.pre_sequence_fn(self, device_type)
	end

	if data.sequence_name then
		if Network:is_server() then
			managers.network:send_to_peers_synched("run_mission_door_sequence", self._unit, data.sequence_name)
		end

		self:run_sequence_simple(data.sequence_name)
	end
end

-- Lines 385-399
function MissionDoor:_initiate_c4_sequence()
	local destroy_except_types = table.set("c4")

	self:_destroy_devices(destroy_except_types)

	local is_server = Network:is_server()

	for _, unit_data in ipairs(self._devices.c4.units) do
		MissionDoor.run_mission_door_device_sequence(unit_data.unit, "activate_explode_sequence")

		if is_server then
			managers.network:send_to_peers_synched("run_mission_door_device_sequence", unit_data.unit, "activate_explode_sequence")
		end
	end

	self._explode_t = TimerManager:game():time() + MissionDoor.C4_EXPLODE_TIME

	self._unit:set_extension_update_enabled(IDS_BASE, true)
end

-- Lines 401-414
function MissionDoor:_c4_sequence_done()
	self._explode_t = nil

	self._unit:set_extension_update_enabled(IDS_BASE, false)

	local device_data = self._devices.c4

	if not device_data then
		return
	end

	for _, unit_data in ipairs(device_data.units) do
		self:device_completed("c4")
	end
end

-- Lines 418-420
function MissionDoor:run_sequence_simple(sequence_name)
	self:_run_sequence_simple(sequence_name)
end

-- Lines 422-427
function MissionDoor:trigger_sequence(trigger_sequence_name)
	self:_run_sequence_simple(trigger_sequence_name)
end

-- Lines 429-436
function MissionDoor:_run_sequence_simple(sequence_name)
	self._unit:damage():run_sequence_simple(sequence_name)
end

-- Lines 446-450
function MissionDoor._on_device_done_event_end_clbk(unit)
	if alive(unit) then
		unit:set_slot(0)
	end
end

-- Lines 452-497
function MissionDoor:_destroy_devices(except_types)
	local is_server = Network:is_server()
	local destroyed_types = {}

	for device_type, device in pairs(self._devices) do
		if not except_types or not except_types[device_type] then
			if except_types then
				table.insert(destroyed_types, device_type)
			end

			for _, unit_data in ipairs(device.units) do
				if alive(unit_data.unit) then
					unit_data.unit:set_visible(false)
					unit_data.unit:set_enabled(false)

					local timer_gui_ext = unit_data.unit:timer_gui()

					if timer_gui_ext then
						timer_gui_ext:hide()
					end

					if is_server or unit_data.unit:id() == -1 then
						if timer_gui_ext and timer_gui_ext:is_playing_done_event() then
							timer_gui_ext:add_listener_to_done_event(MissionDoor._on_device_done_event_end_clbk)
						else
							unit_data.unit:set_slot(0)
						end
					end
				end
			end
		end
	end

	if except_types then
		for _, device_type in ipairs(destroyed_types) do
			self._devices[device_type] = nil
		end
	else
		self._devices = {}
	end
end

-- Lines 499-503
function MissionDoor:destroy(...)
	MissionDoor.super.destroy(self, ...)
	self:_destroy_devices()
end

MissionDoorDevice = MissionDoorDevice or class()

-- Lines 510-514
function MissionDoorDevice:init(unit)
	self._unit = unit

	unit:set_extension_update_enabled(IDS_MISSION_DOOR_DEVICE, false)
end

-- Lines 516-519
function MissionDoorDevice:set_parent_data(door_unit, device_type)
	self._parent_door = door_unit
	self._device_type = device_type
end

-- Lines 521-531
function MissionDoorDevice:placed()
	if not alive(self._parent_door) then
		return
	end

	self._placed = true

	self._parent_door:base():device_placed(self._unit, self._device_type)
end

-- Lines 533-535
function MissionDoorDevice:can_place()
	return not self._placed
end

-- Lines 537-550
function MissionDoorDevice:report_jammed_state(jammed)
	if not alive(self._parent_door) then
		return
	end

	if jammed then
		self._parent_door:base():device_jammed(self._device_type)
	else
		self._parent_door:base():device_resumed(self._device_type)
	end
end

-- Lines 552-561
function MissionDoorDevice:report_resumed()
	if not alive(self._parent_door) then
		return
	end

	self._parent_door:base():device_resumed(self._device_type)
end

-- Lines 563-572
function MissionDoorDevice:report_completed()
	if not alive(self._parent_door) then
		return
	end

	self._parent_door:base():device_completed(self._device_type)
end

-- Lines 574-586
function MissionDoorDevice:report_trigger_sequence(trigger_sequence_name)
	if not alive(self._parent_door) then
		return
	end

	self._parent_door:base():trigger_sequence(trigger_sequence_name)
end
