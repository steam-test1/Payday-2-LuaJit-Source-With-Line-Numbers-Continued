ZipLine = ZipLine or class()
ZipLine.TYPES = {
	"person",
	"bag"
}
ZipLine.NET_EVENTS = {
	request_access = 1,
	access_denied = 2,
	access_granted = 3,
	set_user = 4,
	remove_user = 5,
	request_attach_bag = 6,
	attach_bag_denied = 7,
	attach_bag_granted = 8
}
ZipLine.DEBUG = false
ZipLine.ziplines = ZipLine.ziplines or {}

-- Lines 17-24
function ZipLine.set_debug(state)
	state = state or false
	ZipLine.DEBUG = state

	for i, zipline_unit in ipairs(ZipLine.ziplines) do
		zipline_unit:zipline():set_debug_state(state)
	end
end

local ids_rope_obj = Idstring("rope")

-- Lines 28-72
function ZipLine:init(unit)
	self._unit = unit
	self._rope_obj = unit:get_object(ids_rope_obj)
	self._debug = ZipLine.DEBUG
	ZipLine.debug_brush_1 = ZipLine.debug_brush_1 or Draw:brush(Color.white:with_alpha(0.5))
	ZipLine.debug_brush_2 = ZipLine.debug_brush_2 or Draw:brush(Color.green:with_alpha(0.5))

	self:set_usage_type(self._usage_type or "person")

	ZipLine._wire_brush = ZipLine._wire_brush or Draw:brush(Color.black:with_alpha(1))
	self._current_time = 0
	self._dirty = true
	self._start_pos = self._unit:position()
	self._end_pos = self._start_pos + self._unit:rotation():y() * 1000
	self._speed = 1000
	self._slack = 0

	self:_update_total_time()

	self._line_data = {
		offset = Vector3(0, 0, 200),
		pos = mvector3.copy(self._start_pos),
		current_dir = Vector3()
	}
	self._sled_data = {
		len = 200,
		object = self._unit:get_object(Idstring("move")),
		pos = Vector3(),
		tip1 = Vector3(),
		tip2 = Vector3()
	}
	self._sound_source = SoundDevice:create_source("zipline")

	self._sound_source:link(self._sled_data.object)
	self:_update_pos_data()
	self:set_enabled(true)
	table.insert(ZipLine.ziplines, unit)
end

-- Lines 74-81
function ZipLine:update(unit, t, dt)
	self:_update_sled(t, dt)
	self:_update_sounds(t, dt)

	if self._debug then
		self:debug_draw(t, dt)
	end
end

local mvec1 = Vector3()
local mvec2 = Vector3()

-- Lines 85-150
function ZipLine:_update_sled(t, dt)
	local current_time = self._current_time

	if self._attached_bag then
		if alive(self._attached_bag) then
			self._current_time = math.min(1, self._current_time + dt / self._total_time)
			local dir = math.lerp(self._line_data.dir_s, self._line_data.dir_e, self._current_time)
			local rot = Rotation(dir, math.UP)

			self._attached_bag:set_rotation(rot)

			local pos = self:update_and_get_pos_at_time(self._current_time)

			mvector3.set(mvec1, pos)
			mvector3.set(mvec2, math.UP)
			mvector3.multiply(mvec2, 180)
			mvector3.add(mvec1, mvec2)

			local dot = mvector3.dot(rot:y(), math.UP)

			mvector3.set(mvec2, dir)
			mvector3.multiply(mvec2, 20 * dot)
			mvector3.add(mvec1, mvec2)
			mvector3.set(mvec2, rot:z())
			mvector3.multiply(mvec2, math.abs(dot) * -5 - 3)
			mvector3.add(mvec1, mvec2)
			mvector3.add(mvec1, rot:x() * self._attached_bag_offset.x)
			mvector3.add(mvec1, rot:y() * self._attached_bag_offset.y)
			mvector3.add(mvec1, rot:z() * self._attached_bag_offset.z)
			self._attached_bag:set_position(mvec1)

			if self._current_time == 1 then
				self:release_bag(self._attached_bag)
			end
		else
			self._attached_bag = nil
		end
	elseif not alive(self._user_unit) and self._current_time ~= 0 then
		self._current_time = math.max(0, self._current_time - dt / self._total_time)

		self:update_and_get_pos_at_time(self._current_time)

		if self._current_time == 0 then
			self:_check_interaction_active_state()
		end
	elseif self._synced_user then
		-- Nothing
	end

	self._dirty = self._current_time ~= current_time or self._dirty

	self:_check_dirty()

	if self._synced_user and alive(self._user_unit) and self._sled_data.object then
		local brush = ZipLine._wire_brush
		local pos = self._sled_data.object:position() + self._sled_data.object:rotation():z() * -22

		brush:cylinder(pos, pos + math.UP * -100, 1)
		brush:sphere(pos, 2)
	end
end

-- Lines 152-176
function ZipLine:_update_sounds(t, dt)
	if self._current_time ~= 0 and not self._running then
		self._sound_data = {
			last_pos = mvector3.copy(self._sled_data.pos)
		}

		self._sound_source:post_event("zipline_hook")
		self._sound_source:post_event("zipline_start")

		self._running = true
	elseif self._current_time == 0 and self._running then
		self._sound_data = nil

		self._sound_source:post_event("zipline_stop")

		self._running = false
	elseif self._running then
		local speed = mvector3.length(self._sled_data.pos - self._sound_data.last_pos) / dt

		mvector3.set(self._sound_data.last_pos, self._sled_data.pos)

		local rtpc = math.clamp(speed, 0, 1500) / 1500

		self._sound_source:set_rtpc("zipline_speed", rtpc)

		if not self._sound_data.has_hooked_off and not alive(self._attached_bag) and not alive(self._user_unit) then
			self._sound_source:post_event("zipline_unhook")

			self._sound_data.has_hooked_off = true
		end
	end
end

-- Lines 178-200
function ZipLine:_check_dirty()
	if not self._dirty then
		return
	end

	self._dirty = nil

	mvector3.lerp(self._line_data.current_dir, self._line_data.dir_s, self._line_data.dir_e, self._current_time)

	local len = 16

	mvector3.set(self._sled_data.tip1, self._line_data.current_dir)
	mvector3.multiply(self._sled_data.tip1, -len)
	mvector3.add(self._sled_data.tip1, self._sled_data.pos)
	mvector3.set(self._sled_data.tip2, self._line_data.current_dir)
	mvector3.multiply(self._sled_data.tip2, len)
	mvector3.add(self._sled_data.tip2, self._sled_data.pos)
	self:_update_sled_object()
	self._rope_obj:set_control_points({
		self._line_data.start_pos,
		self._sled_data.tip1,
		self._sled_data.tip2,
		self._line_data.end_pos
	})
end

-- Lines 202-211
function ZipLine:_update_sled_object()
	if self._sled_data.object then
		self._sled_data.object:set_position(self._sled_data.pos)
		self._sled_data.object:set_rotation(Rotation(self._line_data.current_dir, math.UP))
		self._unit:set_moving()

		if self._unit:interaction():active() then
			self._unit:interaction():external_upd_interaction_topology()
		end
	end
end

-- Lines 213-221
function ZipLine:_check_interaction_active_state()
	if not self._enabled then
		self._unit:interaction():set_active(false)

		return
	end

	self._unit:interaction():set_active(not self:is_interact_blocked())
end

-- Lines 223-238
function ZipLine:is_interact_blocked()
	if self._booked_by_peer_id then
		return true
	end

	if self._booked_bag_peer_id then
		return true
	end

	if alive(self._attached_bag) then
		return true
	end

	return self._current_time ~= 0 or alive(self:user_unit())
end

-- Lines 240-269
function ZipLine:on_interacted(unit)
	if self:is_interact_blocked() then
		return
	end

	if self:is_usage_type_bag() then
		if managers.player:is_carrying() then
			if Network:is_server() then
				managers.player:drop_carry(self._unit)
			else
				self:_client_request_attach_bag(unit)
			end

			return
		end

		return
	end

	if self:is_usage_type_person() then
		if Network:is_server() then
			if not alive(self._user_unit) then
				self:set_user(unit)
			end
		else
			self:_client_request_access(unit)
		end
	end
end

-- Lines 271-276
function ZipLine:_client_request_attach_bag(player)
	self._request_unit = player

	player:movement():set_carry_restriction(true)
	managers.network:session():send_to_host("sync_unit_event_id_16", self._unit, "zipline", self.NET_EVENTS.request_attach_bag)
end

-- Lines 278-287
function ZipLine:_attach_bag_response(granted)
	if alive(self._request_unit) then
		self._request_unit:movement():set_carry_restriction(false)

		if granted then
			managers.player:drop_carry(self._unit)
		end
	end

	self._request_unit = nil
end

-- Lines 289-292
function ZipLine:_client_request_access(unit)
	self._request_unit = unit

	managers.network:session():send_to_host("sync_unit_event_id_16", self._unit, "zipline", self.NET_EVENTS.request_access)
end

-- Lines 294-307
function ZipLine:set_user(unit)
	local old_unit = self._user_unit
	self._user_unit = unit

	if self._user_unit then
		self:run_sequence("on_person_enter_zipline", self._user_unit)
		self._user_unit:movement():on_enter_zipline(self._unit)
		self:_send_net_event(self.NET_EVENTS.set_user)
	else
		self:run_sequence("on_person_exit_zipline", old_unit)
		self:_send_net_event(self.NET_EVENTS.remove_user)
	end

	self:_check_interaction_active_state()
end

-- Lines 309-328
function ZipLine:sync_set_user(unit)
	self._booked_by_peer_id = nil
	local old_unit = self._user_unit
	self._user_unit = unit
	self._synced_user = alive(self._user_unit) and true or nil

	if self._user_unit then
		self:run_sequence("on_person_enter_zipline", self._user_unit)
		self._user_unit:movement():on_enter_zipline(self._unit)
	elseif old_unit then
		old_unit:movement():on_exit_zipline()
		self:run_sequence("on_person_exit_zipline", old_unit)
		self:_send_net_event(self.NET_EVENTS.remove_user)
	end

	self:_check_interaction_active_state()
end

-- Lines 330-339
function ZipLine:sync_remove_user()
	if alive(self._user_unit) then
		self:run_sequence("on_person_exit_zipline", self._user_unit)
		self._user_unit:movement():on_exit_zipline()
	end

	self._user_unit = nil
	self._synced_user = nil

	self:_check_interaction_active_state()
end

-- Lines 341-343
function ZipLine:user_unit()
	return self._user_unit
end

-- Lines 345-347
function ZipLine:is_valid()
	return self._start_pos and self._end_pos and true
end

-- Lines 349-355
function ZipLine:set_speed(speed)
	if not speed then
		return
	end

	self._speed = speed

	self:_update_total_time()
end

-- Lines 357-359
function ZipLine:speed()
	return self._speed
end

-- Lines 361-363
function ZipLine:set_ai_ignores_bag(ai_ignores_bag)
	self._ai_ignores_bag = ai_ignores_bag
end

-- Lines 365-367
function ZipLine:ai_ignores_bag()
	return self._ai_ignores_bag
end

-- Lines 369-375
function ZipLine:set_slack(slack)
	if not slack then
		return
	end

	self._slack = slack

	self:_update_pos_data()
end

-- Lines 377-379
function ZipLine:slack()
	return self._slack
end

-- Lines 381-383
function ZipLine:set_total_time(total_time)
	self._total_time = total_time
end

-- Lines 385-387
function ZipLine:total_time()
	return self._total_time
end

-- Lines 389-391
function ZipLine:_update_total_time()
	self:set_total_time((self:start_pos() - self:end_pos()):length() / self._speed)
end

-- Lines 393-395
function ZipLine:start_pos()
	return self._start_pos
end

-- Lines 397-399
function ZipLine:end_pos()
	return self._end_pos
end

-- Lines 401-405
function ZipLine:set_start_pos(pos)
	self._start_pos = pos

	self:_update_pos_data()
	self:_update_total_time()
end

-- Lines 407-411
function ZipLine:set_end_pos(pos)
	self._end_pos = pos

	self:_update_pos_data()
	self:_update_total_time()
end

-- Lines 413-415
function ZipLine:set_end_pos_by_line(pos)
	self:set_end_pos(pos - self._line_data.offset)
end

-- Lines 417-438
function ZipLine:_update_pos_data()
	if not self:is_valid() then
		return
	end

	mvector3.set(self._sled_data.pos, self._start_pos)
	mvector3.add(self._sled_data.pos, self._line_data.offset)

	self._line_data.start_pos = self._start_pos + self._line_data.offset
	self._line_data.end_pos = self._end_pos + self._line_data.offset
	self._line_data.dir = self._line_data.end_pos - self._start_pos
	self._line_data.dir_s = (self:pos_at_time(0.5) + self._line_data.offset - self._line_data.start_pos):normalized()
	self._line_data.dir_e = (self._line_data.end_pos - (self:pos_at_time(0.5) + self._line_data.offset)):normalized()

	mvector3.set_z(self._line_data.dir, 0)
	mvector3.normalize(self._line_data.dir)
	mvector3.set(self._line_data.pos, self._sled_data.pos)

	self._dirty = true
end

-- Lines 440-452
function ZipLine:set_enabled(enabled)
	enabled = enabled or false

	if self._enabled == enabled then
		return
	end

	self._enabled = enabled

	self._unit:set_extension_update_enabled(Idstring("zipline"), enabled)
	self:_check_interaction_active_state()
end

-- Lines 454-460
function ZipLine:set_usage_type(usage_type)
	if not usage_type then
		return
	end

	self._usage_type = usage_type

	self._unit:interaction():set_tweak_data(self:is_usage_type_bag() and "bag_zipline" or "player_zipline")
end

-- Lines 462-464
function ZipLine:usage_type()
	return self._usage_type
end

-- Lines 466-468
function ZipLine:is_usage_type_person()
	return self._usage_type == "person"
end

-- Lines 470-472
function ZipLine:is_usage_type_bag()
	return self._usage_type == "bag"
end

-- Lines 474-476
function ZipLine:current_time()
	return self._current_time
end

-- Lines 478-480
function ZipLine:pos_at_current_time()
	return self:pos_at_time(self._current_time)
end

-- Lines 482-495
function ZipLine:_update_and_get_pos_at_time(time, func)
	self._current_time = time
	self._dirty = true
	local pos = func(self, time)

	mvector3.set(self._sled_data.pos, pos)
	mvector3.add(self._sled_data.pos, self._line_data.offset)
	mvector3.set(self._line_data.pos, self._sled_data.pos)
	self:_check_dirty()

	return pos
end

-- Lines 497-499
function ZipLine:update_and_get_pos_at_time(time)
	return self:_update_and_get_pos_at_time(time, self.pos_at_time)
end

-- Lines 501-503
function ZipLine:update_and_get_pos_at_time_linear(time)
	return self:_update_and_get_pos_at_time(time, self.pos_at_time_linear)
end

local ease_bezier_points = {
	0,
	0,
	1,
	1
}
local slack_bezier_points = {
	0,
	1,
	0.5,
	0
}

-- Lines 507-518
function ZipLine:pos_at_time(time)
	local bezier_value = math.bezier(ease_bezier_points, time)
	local pos = math.lerp(self._start_pos, self._end_pos, bezier_value)
	local slack_bezier = math.bezier(slack_bezier_points, bezier_value)
	local slack = math.lerp(0, self._slack, slack_bezier)

	mvector3.set_z(pos, mvector3.z(pos) - slack)

	return pos
end

-- Lines 520-526
function ZipLine:pos_at_time_linear(time)
	local pos = math.lerp(self._start_pos, self._end_pos, time)
	local slack_bezier = math.bezier(slack_bezier_points, time)
	local slack = math.lerp(0, self._slack, slack_bezier)

	mvector3.set_z(pos, mvector3.z(pos) - slack)

	return pos
end

-- Lines 528-537
function ZipLine:speed_at_time(time, step)
	step = step or 0.01
	local pos1 = self:pos_at_time(time)
	local pos2 = self:pos_at_time(math.clamp(time + step, 0, 1))
	local dist = mvector3.distance(pos1, pos2)

	return dist
end

-- Lines 539-541
function ZipLine:current_direction()
	return self._line_data.current_dir
end

-- Lines 545-595
function ZipLine:sync_net_event(event_id, peer)
	local net_events = self.NET_EVENTS

	if event_id == net_events.request_access then
		print("! request_access")

		if self:is_interact_blocked() then
			print(" blocked")
			peer:send_queued_sync("sync_unit_event_id_16", self._unit, "zipline", self.NET_EVENTS.access_denied)
		else
			print(" allowed")

			self._booked_by_peer_id = peer:id()

			peer:send_queued_sync("sync_unit_event_id_16", self._unit, "zipline", self.NET_EVENTS.access_granted)
		end
	elseif event_id == net_events.access_denied then
		print("! access_denied")

		self._request_unit = nil
	elseif event_id == net_events.access_granted then
		print("! access_granted")

		if alive(self._request_unit) then
			self:set_user(self._request_unit)
		end

		self._request_unit = nil
	elseif event_id == net_events.set_user then
		print("! set user")

		local unit = peer:unit()

		if alive(unit) then
			self:sync_set_user(unit)
		end
	elseif event_id == net_events.remove_user then
		print("! remove user")
		self:sync_remove_user()
	elseif event_id == net_events.request_attach_bag then
		print("! net_events.request_attach_bag")

		if self:is_interact_blocked() then
			print(" respons attach_bag_denied")
			peer:send_queued_sync("sync_unit_event_id_16", self._unit, "zipline", self.NET_EVENTS.attach_bag_denied)
		else
			self._booked_bag_peer_id = peer:id()

			print(" respons attach_bag_granted")
			peer:send_queued_sync("sync_unit_event_id_16", self._unit, "zipline", self.NET_EVENTS.attach_bag_granted)
		end
	elseif event_id == net_events.attach_bag_denied then
		print("! net_events.attach_bag_denied")
		self:_attach_bag_response(false)
	elseif event_id == net_events.attach_bag_granted then
		print("! net_events.attach_bag_granted")
		self:_attach_bag_response(true)
	end
end

-- Lines 597-599
function ZipLine:_send_net_event(event_id)
	managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "zipline", event_id)
end

-- Lines 603-634
function ZipLine:attach_bag(bag)
	self._booked_bag_peer_id = nil
	local body = bag:body("hinge_body_1") or bag:body(0)

	body:set_keyframed()

	self._attached_bag = bag

	self._unit:link(bag)

	local carry_id = self._attached_bag:carry_data():carry_id()
	self._attached_bag_offset = tweak_data.carry:get_zipline_offset(carry_id)
	self._bag_disabled_collisions = {}
	local nr_bodies = bag:num_bodies()

	for i_body = 0, nr_bodies - 1 do
		local body = bag:body(i_body)

		if body:collisions_enabled() then
			body:set_keyframed()
			table.insert(self._bag_disabled_collisions, body)
			body:set_collisions_enabled(false)
		end
	end

	self._attached_bag:set_rotation(Rotation(self._line_data.dir_s, math.UP))
	self._attached_bag:carry_data():set_zipline_unit(self._unit)
	self:_check_interaction_active_state()
	self:run_sequence("on_attached_bag", self._attached_bag)
end

-- Lines 636-657
function ZipLine:release_bag()
	local body = self._attached_bag:body("hinge_body_1") or self._attached_bag:body(0)

	body:set_dynamic()
	self._attached_bag:unlink()

	if self._bag_disabled_collisions then
		for _, body in ipairs(self._bag_disabled_collisions) do
			body:set_dynamic()
			body:set_collisions_enabled(true)
		end

		self._bag_disabled_collisions = nil
	end

	self._attached_bag:carry_data():set_zipline_unit(nil)
	self:run_sequence("on_detached_bag", self._attached_bag)

	self._attached_bag = nil
end

-- Lines 661-665
function ZipLine:run_sequence(sequence_name, user_unit)
	if self._unit:damage():has_sequence(sequence_name) then
		self._unit:damage():run_sequence_simple(sequence_name, {
			unit = user_unit
		})
	end
end

-- Lines 669-671
function ZipLine:destroy(unit)
	table.delete(ZipLine.ziplines, self._unit)
end

-- Lines 673-675
function ZipLine:set_debug_state(state)
	self._debug = state
end

-- Lines 677-695
function ZipLine:debug_draw(t, dt)
	if not self:is_valid() then
		return
	end

	local brush = ZipLine.debug_brush_1

	for i = 0, 1, 0.005 do
		brush:sphere(self:pos_at_time(i), 2)
	end

	local offset = Vector3(0, 0, 200)
	local brush = ZipLine.debug_brush_2
	local pos = self:pos_at_time((1 + math.sin(t * 50)) / 2)

	brush:cylinder(self._start_pos + offset, pos + offset, 1)
	brush:cylinder(pos + offset, self._end_pos + offset, 1)
	brush:sphere(pos + offset + Vector3(0, 0, 10), 10)
	brush:sphere(pos, 10)
end

-- Lines 697-708
function ZipLine:save(data)
	local state = {
		enabled = self._enabled,
		current_time = self._current_time,
		end_pos = self._end_pos,
		speed = self._speed,
		slack = self._slack,
		usage_type = self._usage_type
	}
	data.ZipLine = state
end

-- Lines 710-722
function ZipLine:load(data)
	local state = data.ZipLine

	self:set_enabled(state.enabled)
	self:set_end_pos(state.end_pos)
	self:set_speed(state.speed)
	self:set_slack(state.slack)
	self:set_usage_type(state.usage_type)

	self._current_time = state.current_time

	managers.worlddefinition:use_me(self._unit)
end
