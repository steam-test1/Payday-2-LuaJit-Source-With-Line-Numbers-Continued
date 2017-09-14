core:import("CoreMissionScriptElement")

ElementLaserTrigger = ElementLaserTrigger or class(CoreMissionScriptElement.MissionScriptElement)
ElementLaserTrigger.COLORS = {
	red = {
		1,
		0,
		0
	},
	green = {
		0,
		1,
		0
	},
	blue = {
		0,
		0,
		1
	}
}

-- Lines: 6 to 58
function ElementLaserTrigger:init(...)
	ElementLaserTrigger.super.init(self, ...)

	self._brush = Draw:brush(Color(0.15, unpack(self.COLORS[self._values.color])))

	self._brush:set_blend_mode("opacity_add")

	self._last_project_amount_all = 0
	self._inside = {}
	self._connections = {}
	self._is_cycled = self._values.cycle_interval ~= 0
	self._next_cycle_t = 0
	self._cycle_index = 1
	self._cycle_order = {}
	self._slotmask = managers.slot:get_mask("persons")

	if self._values.instigator == "enemies" then
		self._slotmask = managers.slot:get_mask("enemies")
	elseif self._values.instigator == "civilians" then
		self._slotmask = managers.slot:get_mask("civilians")
	elseif self._values.instigator == "loot" then
		self._slotmask = World:make_slot_mask(14)
	end

	if not self._values.skip_dummies then
		self._dummy_units = {}
		self._dummies_visible = true

		for _, point in pairs(self._values.points) do
			local unit = safe_spawn_unit(Idstring("units/payday2/props/gen_prop_lazer_blaster_dome/gen_prop_lazer_blaster_dome"), point.pos, point.rot)
			local materials = unit:get_objects_by_type(Idstring("material"))

			for _, m in ipairs(materials) do
				m:set_variable(Idstring("contour_opacity"), 0)
			end

			table.insert(self._dummy_units, unit)

			point.pos = point.pos + point.rot:y() * 3
		end
	end

	for i, connection in ipairs(self._values.connections) do
		table.insert(self._cycle_order, i)
		table.insert(self._connections, {
			enabled = not self._is_cycled,
			from = self._values.points[connection.from],
			to = self._values.points[connection.to]
		})
	end

	if self._values.cycle_random then
		local cycle_order = clone(self._cycle_order)
		self._cycle_order = {}

		while #cycle_order > 0 do
			table.insert(self._cycle_order, table.remove(cycle_order, math.random(#cycle_order)))
		end
	end
end

-- Lines: 60 to 67
function ElementLaserTrigger:on_script_activated(...)
	ElementLaserTrigger.super.on_script_activated(self, ...)
	self._mission_script:add_save_state_cb(self._id)

	if self._values.enabled then
		self:add_callback()
	end
end

-- Lines: 69 to 77
function ElementLaserTrigger:set_enabled(enabled)
	ElementLaserTrigger.super.set_enabled(self, enabled)

	if enabled then
		self._delayed_remove = nil

		self:add_callback()
	else
		self:remove_callback()
	end
end

-- Lines: 79 to 86
function ElementLaserTrigger:add_callback()
	if not self._callback then
		if not self._values.visual_only then
			self._callback = self._mission_script:add(callback(self, self, "update_laser"), self._values.interval)
		end

		self._mission_script:add_updator(self._id, callback(self, self, "update_laser_draw"))
	end
end

-- Lines: 88 to 100
function ElementLaserTrigger:remove_callback()
	if self._callback then
		self._mission_script:remove(self._callback)

		self._callback = nil
	end

	if self._values.flicker_remove then
		self._delayed_remove = 7
		self._delayed_remove_t = 0
		self._delayed_remove_state_on = true
	else
		self._mission_script:remove_updator(self._id)
	end
end

-- Lines: 103 to 104
function ElementLaserTrigger:client_on_executed(...)
end

-- Lines: 106 to 117
function ElementLaserTrigger:on_executed(instigator, alternative)
	if not self._values.enabled then
		return
	end

	ElementLaserTrigger.super.on_executed(self, instigator, alternative)

	if not self._values.enabled then
		self:remove_callback()
	end
end

-- Lines: 120 to 121
function ElementLaserTrigger:instigators()
	return ElementAreaTrigger.project_instigators(self)
end

-- Lines: 124 to 141
function ElementLaserTrigger:_check_delayed_remove(t, dt)
	if not self._delayed_remove then
		return false
	end

	if self._delayed_remove_t <= 0 then
		self._delayed_remove_state_on = not self._delayed_remove_state_on
		self._delayed_remove_t = 0.05 + math.rand(0.05)
		self._delayed_remove = self._delayed_remove - 1

		if self._delayed_remove <= 0 then
			self._mission_script:remove_updator(self._id)
		end
	end

	self._delayed_remove_t = self._delayed_remove_t - dt

	if not self._delayed_remove_state_on then
		return true
	end

	return false
end

-- Lines: 144 to 185
function ElementLaserTrigger:update_laser_draw(t, dt)
	if #self._connections == 0 then
		return
	end

	if self:_check_delayed_remove(t, dt) then
		return
	end

	for _, connection in ipairs(self._connections) do
		if connection.enabled then
			self._brush:cylinder(connection.from.pos, connection.to.pos, 0.5)
		end
	end

	if self._is_cycled then
		self._next_cycle_t = self._next_cycle_t - dt

		if self._next_cycle_t <= 0 then
			self._next_cycle_t = self._values.cycle_interval

			for i, connection in ipairs(self._connections) do
				connection.enabled = false
			end

			local index = self._cycle_index - 1

			for j = 1, self._values.cycle_active_amount, 1 do
				index = index + 1

				if #self._cycle_order < index then
					index = 1
				end

				self._connections[self._cycle_order[index]].enabled = true
			end

			self._cycle_index = (self._values.cycle_type == "pop" and index or self._cycle_index) + 1

			if #self._cycle_order < self._cycle_index then
				self._cycle_index = 1
			end
		end
	end
end

-- Lines: 187 to 188
function ElementLaserTrigger:project_amount_all()
	return ElementAreaTrigger.project_amount_all(self)
end

-- Lines: 191 to 211
function ElementLaserTrigger:update_laser()
	if not self._values.enabled then
		return
	end

	local instigators = self:instigators()

	if #instigators == 0 and Network:is_server() then
		self:_check_state(nil)
	else
		for _, unit in ipairs(instigators) do
			if alive(unit) then
				if Network:is_client() then
					self:_client_check_state(unit)
				else
					self:_check_state(unit)
				end
			end
		end
	end
end

-- Lines: 214 to 216
function ElementLaserTrigger:sync_enter_area(unit)
	self:_add_inside(unit)
end

-- Lines: 219 to 221
function ElementLaserTrigger:sync_exit_area(unit)
	self:_remove_inside(unit)
end

-- Lines: 224 to 226
function ElementLaserTrigger:sync_while_in_area(unit)
	self:_while_inside(unit)
end

-- Lines: 244 to 305
function ElementLaserTrigger:_check_state(unit)
	if alive(unit) then
		local rule_ok = self:_check_instigator_rules(unit)
		local inside = nil
		local mover = unit:mover()

		if mover then
			for i, connection in ipairs(self._connections) do
				if connection.enabled then
					inside = mover:line_intersection(connection.from.pos, connection.to.pos)

					if inside then
						break
					end
				end
			end
		else
			local oobb = unit:oobb()

			for i, connection in ipairs(self._connections) do
				if connection.enabled then
					local hit_oobb = oobb:raycast(connection.from.pos, connection.to.pos)

					if hit_oobb then
						inside = World:raycast("ray", connection.from.pos, connection.to.pos, "target_unit", unit, "slot_mask", self._slotmask, "report")
					end

					if inside then
						break
					end
				end
			end
		end

		if table.contains(self._inside, unit) then
			if not inside or not rule_ok then
				self:_remove_inside(unit)
			end
		elseif inside and rule_ok then
			self:_add_inside(unit)
		end

		if inside and rule_ok then
			self:_while_inside(unit)
		end
	end

	local project_amount_all = self:project_amount_all()

	if project_amount_all ~= self._last_project_amount_all then
		self._last_project_amount_all = project_amount_all

		self:_clean_destroyed_units()

		return true
	end

	return false
end

-- Lines: 308 to 311
function ElementLaserTrigger:_add_inside(unit)
	table.insert(self._inside, unit)
	self:on_executed(unit, "enter")
end

-- Lines: 313 to 315
function ElementLaserTrigger:_while_inside(unit)
	self:on_executed(unit, "while_inside")
end

-- Lines: 317 to 323
function ElementLaserTrigger:_remove_inside(unit)
	table.delete(self._inside, unit)
	self:on_executed(unit, "leave")

	if #self._inside == 0 then
		self:on_executed(unit, "empty")
	end
end

-- Lines: 325 to 331
function ElementLaserTrigger:_remove_inside_by_index(index)
	table.remove(self._inside, index)
	self:on_executed(nil, "leave")

	if #self._inside == 0 then
		self:on_executed(nil, "empty")
	end
end

-- Lines: 334 to 344
function ElementLaserTrigger:_check_instigator_rules(unit)
	if not self._rules_elements then
		return true
	end

	for _, element in ipairs(self._rules_elements) do
		if not element:check_rules(self._values.instigator, unit) then
			return false
		end
	end

	return true
end

-- Lines: 348 to 357
function ElementLaserTrigger:_clean_destroyed_units()
	local i = 1

	while next(self._inside) and i <= #self._inside do
		if alive(self._inside[i]) then
			i = i + 1
		else
			self:_remove_inside_by_index(i)
		end
	end
end

-- Lines: 360 to 393
function ElementLaserTrigger:_client_check_state(unit)
	local rule_ok = self:_check_instigator_rules(unit)
	local inside = nil
	local mover = unit:mover()

	if mover then
		for i, connection in ipairs(self._connections) do
			if connection.enabled then
				inside = mover:line_intersection(connection.from.pos, connection.to.pos)

				if inside then
					break
				end
			end
		end
	end

	if table.contains(self._inside, unit) then
		if not inside or not rule_ok then
			table.delete(self._inside, unit)
			managers.network:session():send_to_host("to_server_area_event", 2, self._id, unit)
		end
	elseif inside and rule_ok then
		table.insert(self._inside, unit)
		managers.network:session():send_to_host("to_server_area_event", 1, self._id, unit)
	end

	if inside and rule_ok then
		managers.network:session():send_to_host("to_server_area_event", 3, self._id, unit)
	end
end

-- Lines: 395 to 397
function ElementLaserTrigger:operation_add()
	self:_set_dummies_visible(true)
end

-- Lines: 399 to 401
function ElementLaserTrigger:operation_remove()
	self:_set_dummies_visible(false)
end

-- Lines: 403 to 412
function ElementLaserTrigger:_set_dummies_visible(visible)
	if not self._dummy_units then
		return
	end

	self._dummies_visible = visible

	for _, unit in ipairs(self._dummy_units) do
		unit:set_enabled(self._dummies_visible)
	end
end

-- Lines: 415 to 421
function ElementLaserTrigger:save(data)
	data.enabled = self._values.enabled
	data.cycle_order = self._cycle_order
	data.cycle_index = self._cycle_index
	data.next_cycle_t = self._next_cycle_t
	data.dummies_visible = self._dummies_visible
end

-- Lines: 423 to 429
function ElementLaserTrigger:load(data)
	self:set_enabled(data.enabled)

	self._cycle_order = data.cycle_order
	self._cycle_index = data.cycle_index
	self._next_cycle_t = data.next_cycle_t

	self:_set_dummies_visible(data.dummies_visible)
end

