BuffBalloon = BuffBalloon or class()
local balloon_units = {
	"units/pd2_dlc_a10th/props/a10th_balloon/a10th_balloon_zigzag",
	"units/pd2_dlc_a10th/props/a10th_balloon/a10th_balloon_diamonds",
	"units/pd2_dlc_a10th/props/a10th_balloon/a10th_balloon_stars",
	"units/pd2_dlc_a10th/props/a10th_balloon/a10th_balloon_stripes",
	"units/pd2_dlc_a10th/props/a10th_balloon/a10th_balloon_polkas",
	"units/pd2_dlc_a10th/props/a10th_balloon/a10th_balloon_polkal"
}

-- Lines 12-23
function BuffBalloon.spawn(pos, rot, buff_id)
	buff_id = buff_id or 0

	if buff_id > 0 then
		local unit = World:spawn_unit(Idstring(balloon_units[buff_id]), pos, rot)

		managers.network:session():send_to_peers_synched("sync_a10th_balloon_setup", unit, buff_id)
		unit:base():set_buff_id(buff_id)

		return unit
	else
		print("[BuffBalloon] .spawn() FAILED TO SPAWN BALLOON", buff_id)
	end

	return nil
end

-- Lines 25-32
function BuffBalloon:init(unit)
	self._unit = unit
	self._buff_id = 0
	self._destroyed = false
	self._speed = 100
end

-- Lines 34-39
function BuffBalloon:update(unit, t, dt)
	local body = self._unit:body("body_static")

	if body:enabled() and not self._destroyed then
		body:set_velocity(Vector3(0, 0, self._speed))
	end
end

-- Lines 41-44
function BuffBalloon:set_buff_id(buff_id)
	print("[BuffBalloon] set_buff_id()", buff_id)

	self._buff_id = buff_id
end

-- Lines 46-58
function BuffBalloon:on_balloon_shot()
	print("[BuffBalloon] on_balloon_shot()")

	if not self._destroyed then
		self._destroyed = true
	end
end

-- Lines 69-75
function BuffBalloon:self_destruct()
	print("[BuffBalloon] self_destruct()")

	if not self._destroyed then
		self._destroyed = true

		self._unit:set_slot(0)
	end
end
