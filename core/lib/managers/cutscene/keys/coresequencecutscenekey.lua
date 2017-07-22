require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")

CoreSequenceCutsceneKey = CoreSequenceCutsceneKey or class(CoreCutsceneKeyBase)
CoreSequenceCutsceneKey.ELEMENT_NAME = "sequence"
CoreSequenceCutsceneKey.NAME = "Sequence"

CoreSequenceCutsceneKey:register_serialized_attribute("unit_name", "")
CoreSequenceCutsceneKey:register_serialized_attribute("name", "")
CoreSequenceCutsceneKey:attribute_affects("unit_name", "name")

CoreSequenceCutsceneKey.control_for_name = CoreCutsceneKeyBase.standard_combo_box_control

-- Lines: 11 to 12
function CoreSequenceCutsceneKey:__tostring()
	return "Trigger sequence \"" .. self:name() .. "\" on \"" .. self:unit_name() .. "\"."
end

-- Lines: 15 to 17
function CoreSequenceCutsceneKey:evaluate(player, fast_forward)
	self:_unit_extension(self:unit_name(), "damage"):run_sequence_simple(self:name())
end

-- Lines: 19 to 21
function CoreSequenceCutsceneKey:revert(player)
	self:_run_sequence_if_exists("undo_" .. self:name())
end

-- Lines: 23 to 25
function CoreSequenceCutsceneKey:skip(player)
	self:_run_sequence_if_exists("skip_" .. self:name())
end

-- Lines: 27 to 33
function CoreSequenceCutsceneKey:is_valid_unit_name(unit_name)
	if not self.super.is_valid_unit_name(self, unit_name) then
		return false
	end

	local unit = self:_unit(unit_name, true)

	return unit ~= nil and managers.sequence:has(unit_name)
end

-- Lines: 36 to 38
function CoreSequenceCutsceneKey:is_valid_name(name)
	local unit = self:_unit(self:unit_name(), true)

	return unit ~= nil and not string.begins(name, "undo_") and not string.begins(name, "skip_") and managers.sequence:has_sequence_name(self:unit_name(), name)
end

-- Lines: 41 to 59
function CoreSequenceCutsceneKey:refresh_control_for_name(control)
	control:freeze()
	control:clear()

	local unit = self:_unit(self:unit_name(), true)
	local sequence_names = unit and managers.sequence:get_sequence_list(self:unit_name()) or {}

	if not table.empty(sequence_names) then
		control:set_enabled(true)

		local value = self:name()

		for _, name in ipairs(sequence_names) do
			control:append(name)

			if name == value then
				control:set_value(value)
			end
		end
	else
		control:set_enabled(false)
	end

	control:thaw()
end

-- Lines: 61 to 66
function CoreSequenceCutsceneKey:_run_sequence_if_exists(sequence_name)
	local unit = self:_unit(self:unit_name())

	if managers.sequence:has_sequence_name(self:unit_name(), sequence_name) then
		self:_unit_extension(self:unit_name(), "damage"):run_sequence_simple(sequence_name)
	end
end

return
