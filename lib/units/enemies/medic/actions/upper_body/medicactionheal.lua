MedicActionHeal = MedicActionHeal or class()

-- Lines 3-23
function MedicActionHeal:init(action_desc, common_data)
	self._common_data = common_data
	self._ext_movement = common_data.ext_movement
	self._ext_inventory = common_data.ext_inventory
	self._ext_anim = common_data.ext_anim
	self._body_part = action_desc.body_part
	self._unit = common_data.unit
	self._machine = common_data.machine
	self._attention = common_data.attention
	self._action_desc = action_desc

	self._ext_movement:play_redirect("heal")
	self._unit:sound():say("heal", true)

	self._done = false

	self:check_achievements()

	return true
end

-- Lines 25-29
function MedicActionHeal:on_exit()
	if self._unit:contour() then
		self._unit:contour():remove("medic_healing", true)
	end
end

-- Lines 31-37
function MedicActionHeal:update(t)
	if not self._unit:anim_data().healing then
		self._done = true

		self._ext_movement:play_redirect("idle")
		self._ext_movement:action_request({
			body_part = 2,
			type = "idle"
		})
	end
end

-- Lines 39-41
function MedicActionHeal:type()
	return "heal"
end

-- Lines 43-45
function MedicActionHeal:expired()
	return self._expired
end

-- Lines 47-52
function MedicActionHeal:chk_block(action_type, t)
	if action_type == "heavy_hurt" or action_type == "hurt" or action_type == "death" then
		return false
	end

	return not self._done
end

-- Lines 54-56
function MedicActionHeal:on_attention(attention)
	self._attention = attention
end

-- Lines 58-60
function MedicActionHeal:body_part()
	return self._body_part
end

-- Lines 62-64
function MedicActionHeal:need_upd()
	return true
end

-- Lines 66-72
function MedicActionHeal:save(save_data)
	for i, k in pairs(self._action_desc) do
		if type_name(k) ~= "Unit" or alive(k) then
			save_data[i] = k
		end
	end
end

-- Lines 77-100
function MedicActionHeal:check_achievements()
	local total_healed = (managers.job:get_memory("medic_heal_total", true) or 0) + 1

	managers.job:set_memory("medic_heal_total", total_healed, true)

	local all_pass, total_pass = nil

	for achievement, achievement_data in pairs(tweak_data.achievement.medic_heal_achievements or {}) do
		total_pass = not achievement_data.total

		if achievement_data.total then
			total_pass = achievement_data.total <= total_healed
		end

		all_pass = total_pass

		if all_pass then
			managers.achievment:award_data(achievement_data)
		end
	end
end
