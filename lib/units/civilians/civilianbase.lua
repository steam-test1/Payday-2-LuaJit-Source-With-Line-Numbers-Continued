CivilianBase = CivilianBase or class(CopBase)

-- Lines: 3 to 25
function CivilianBase:post_init()
	self._ext_movement = self._unit:movement()
	self._ext_anim = self._unit:anim_data()
	local spawn_state = nil

	if not self._spawn_state or self._spawn_state ~= "" and self._spawn_state then
		spawn_state = "civilian/spawn/loop"
	end

	if spawn_state then
		self._ext_movement:play_state(spawn_state)
	end

	self._unit:anim_data().idle_full_blend = true

	self._ext_movement:post_init()
	self._unit:brain():post_init()
	managers.enemy:register_civilian(self._unit)
	self:enable_leg_arm_hitbox()
end

-- Lines: 28 to 29
function CivilianBase:default_weapon_name()
end

