SmokeScreenEffect = SmokeScreenEffect or class()

-- Lines 4-29
function SmokeScreenEffect:init(position, normal, time, has_dodge_bonus, grenade_unit)
	self._timer = time
	self._position = position
	self._radius = 400
	self._unit_list = {}
	self._dodge_bonus = has_dodge_bonus and managers.player:upgrade_value_by_level("player", "smoke_screen_ally_dodge_bonus", 1) or 0
	self._sound_source = SoundDevice:create_source("ExplosionManager")

	self._sound_source:set_position(position)
	self._sound_source:post_event("lung_explode")

	self._effect = World:effect_manager():spawn({
		effect = Idstring("effects/particles/explosions/smoke_screen"),
		position = position,
		normal = normal
	})

	if alive(grenade_unit) then
		local base_ext = grenade_unit:base()

		if base_ext then
			self._variant = base_ext._projectile_entry
			self._mine = base_ext:thrower_unit() == managers.player:player_unit()
		end
	end
end

-- Lines 31-33
function SmokeScreenEffect:variant()
	return self._variant
end

-- Lines 35-37
function SmokeScreenEffect:dodge_bonus()
	return self._dodge_bonus
end

-- Lines 39-41
function SmokeScreenEffect:position()
	return self._position
end

-- Lines 43-45
function SmokeScreenEffect:alive()
	return not not self._timer
end

-- Lines 47-49
function SmokeScreenEffect:is_in_smoke(unit)
	return self._unit_list[unit:key()], self._variant
end

-- Lines 87-89
function SmokeScreenEffect:mine()
	return self._mine
end

-- Lines 91-112
function SmokeScreenEffect:update(t, dt)
	if self._timer then
		self._timer = self._timer - dt

		if self._timer <= 2 then
			World:effect_manager():fade_kill(self._effect)

			if not self._sound_killed then
				self._sound_source:post_event("lung_loop_end")
				managers.enemy:add_delayed_clbk("SmokeScreenEffect", callback(ProjectileBase, ProjectileBase, "_dispose_of_sound", {
					sound_source = self._sound_source
				}), TimerManager:game():time() + 4)

				self._sound_killed = true
			end
		end

		if self._timer <= 0 then
			self._timer = nil
		end
	end

	self._unit_list = {}

	local nearby_units = World:find_units_quick("sphere", self._position, self._radius, managers.slot:get_mask("persons"))

	for _, unit in ipairs(nearby_units) do
		self._unit_list[unit:key()] = true
	end
end

-- Lines 114-118
function SmokeScreenEffect:destroy()
	if self._effect then
		World:effect_manager():kill(self._effect)
	end
end
