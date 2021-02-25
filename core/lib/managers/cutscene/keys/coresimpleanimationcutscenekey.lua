require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")

CoreSimpleAnimationCutsceneKey = CoreSimpleAnimationCutsceneKey or class(CoreCutsceneKeyBase)
CoreSimpleAnimationCutsceneKey.ELEMENT_NAME = "simple_animation"
CoreSimpleAnimationCutsceneKey.NAME = "Simple Animation"

CoreSimpleAnimationCutsceneKey:register_serialized_attribute("unit_name", "")
CoreSimpleAnimationCutsceneKey:register_serialized_attribute("group", "")
CoreSimpleAnimationCutsceneKey:attribute_affects("unit_name", "group")

CoreSimpleAnimationCutsceneKey.control_for_group = CoreCutsceneKeyBase.standard_combo_box_control

-- Lines 11-13
function CoreSimpleAnimationCutsceneKey:__tostring()
	return "Trigger simple animation \"" .. self:group() .. "\" on \"" .. self:unit_name() .. "\"."
end

-- Lines 15-21
function CoreSimpleAnimationCutsceneKey:skip(player)
	local unit = self:_unit(self:unit_name())
	local group = self:group()

	unit:anim_play(group, 0)
	unit:anim_set_time(group, unit:anim_length(group))
end

-- Lines 23-25
function CoreSimpleAnimationCutsceneKey:evaluate(player, fast_forward)
	self:_unit(self:unit_name()):anim_play(self:group(), 0)
end

-- Lines 27-35
function CoreSimpleAnimationCutsceneKey:revert(player)
	local unit = self:_unit(self:unit_name())
	local group = self:group()

	if unit:anim_is_playing(group) then
		unit:anim_set_time(group, 0)
		unit:anim_stop(group)
	end
end

-- Lines 37-39
function CoreSimpleAnimationCutsceneKey:update(player, time)
	self:_unit(self:unit_name()):anim_set_time(self:group(), time)
end

-- Lines 41-43
function CoreSimpleAnimationCutsceneKey:is_valid_unit_name(unit_name)
	return self.super.is_valid_unit_name(self, unit_name) and #self:_unit_animation_groups(unit_name) > 0
end

-- Lines 45-47
function CoreSimpleAnimationCutsceneKey:is_valid_group(group)
	return table.contains(self:_unit_animation_groups(self:unit_name()), group)
end

-- Lines 49-66
function CoreSimpleAnimationCutsceneKey:refresh_control_for_group(control)
	control:freeze()
	control:clear()

	local groups = self:_unit_animation_groups(self:unit_name())

	if not table.empty(groups) then
		control:set_enabled(true)

		local value = self:group()

		for _, group in ipairs(groups) do
			control:append(group)

			if group == value then
				control:set_value(group)
			end
		end
	else
		control:set_enabled(false)
	end

	control:thaw()
end
