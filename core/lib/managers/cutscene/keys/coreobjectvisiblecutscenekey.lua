require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")

CoreObjectVisibleCutsceneKey = CoreObjectVisibleCutsceneKey or class(CoreCutsceneKeyBase)
CoreObjectVisibleCutsceneKey.ELEMENT_NAME = "object_visible"
CoreObjectVisibleCutsceneKey.NAME = "Object Visibility"

CoreObjectVisibleCutsceneKey:register_serialized_attribute("unit_name", "")
CoreObjectVisibleCutsceneKey:register_serialized_attribute("object_name", "")
CoreObjectVisibleCutsceneKey:register_serialized_attribute("visible", true, toboolean)


-- Lines: 10 to 11
function CoreObjectVisibleCutsceneKey:__tostring()
	return (self:visible() and "Show" or "Hide") .. " \"" .. self:object_name() .. "\" in \"" .. self:unit_name() .. "\"."
end

-- Lines: 14 to 18
function CoreObjectVisibleCutsceneKey:unload(player)
	if player and self._cast then
		self:play(player, true)
	end
end

-- Lines: 20 to 24
function CoreObjectVisibleCutsceneKey:skip(player)
	if self._cast then
		self:play(player)
	end
end

-- Lines: 26 to 37
function CoreObjectVisibleCutsceneKey:play(player, undo, fast_forward)
	if undo then
		local preceeding_key = self:preceeding_key({
			unit_name = self:unit_name(),
			object_name = self:object_name()
		})

		if preceeding_key then
			preceeding_key:evaluate(player, false)
		else
			self:evaluate(player, false, self:_unit_initial_object_visibility(self:unit_name(), self:object_name()))
		end
	else
		self:evaluate(player, fast_forward)
	end
end

-- Lines: 39 to 43
function CoreObjectVisibleCutsceneKey:evaluate(player, fast_forward, visible)
	assert(self._cast)

	local object = self:_unit_object(self:unit_name(), self:object_name())

	object:set_visibility(visible == nil and self:visible() or visible)
end

-- Lines: 45 to 52
function CoreObjectVisibleCutsceneKey:is_valid_object_name(object_name)
	if not self.super.is_valid_object_name(self, object_name) then
		return false
	else
		local object = self:_unit_object(self:unit_name(), object_name, true)

		return object and object.set_visibility ~= nil
	end
end

