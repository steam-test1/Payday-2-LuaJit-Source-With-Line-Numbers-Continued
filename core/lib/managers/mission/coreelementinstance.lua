core:module("CoreElementInstance")
core:import("CoreMissionScriptElement")

ElementInstanceInput = ElementInstanceInput or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 8-16
function ElementInstanceInput:init(...)
	ElementInstanceInput.super.init(self, ...)

	if self._values.instance_name then
		managers.world_instance:register_input_element(self._values.instance_name, self._values.event, self)
	end
end

-- Lines 19-25
function ElementInstanceInput:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementInstanceInput.super.on_executed(self, instigator)
end

ElementInstanceOutput = ElementInstanceOutput or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 31-34
function ElementInstanceOutput:on_created()
	self._output_elements = managers.world_instance:get_registered_output_event_elements(self._values.instance_name, self._values.event)
end

-- Lines 37-49
function ElementInstanceOutput:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if self._output_elements then
		for _, element in ipairs(self._output_elements) do
			element:on_executed(instigator)
		end
	end

	ElementInstanceOutput.super.on_executed(self, instigator)
end

ElementInstanceInputEvent = ElementInstanceInputEvent or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 55-80
function ElementInstanceInputEvent:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if self._values.instance then
		local input_elements = managers.world_instance:get_registered_input_elements(self._values.instance, self._values.event)

		if input_elements then
			for _, element in ipairs(input_elements) do
				element:on_executed(instigator)
			end
		end
	elseif self._values.event_list then
		for _, event_list_data in ipairs(self._values.event_list) do
			local input_elements = managers.world_instance:get_registered_input_elements(event_list_data.instance, event_list_data.event)

			if input_elements then
				for _, element in ipairs(input_elements) do
					element:on_executed(instigator)
				end
			end
		end
	end

	ElementInstanceInputEvent.super.on_executed(self, instigator)
end

ElementInstanceOutputEvent = ElementInstanceOutputEvent or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 86-98
function ElementInstanceOutputEvent:init(...)
	ElementInstanceOutputEvent.super.init(self, ...)

	if self._values.instance then
		managers.world_instance:register_output_event_element(self._values.instance, self._values.event, self)
	end

	if self._values.event_list then
		for _, event_list_data in ipairs(self._values.event_list) do
			managers.world_instance:register_output_event_element(event_list_data.instance, event_list_data.event, self)
		end
	end
end

-- Lines 101-107
function ElementInstanceOutputEvent:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementInstanceOutputEvent.super.on_executed(self, instigator)
end

ElementInstancePoint = ElementInstancePoint or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 113-115
function ElementInstancePoint:client_on_executed(...)
	return
end

-- Lines 118-126
function ElementInstancePoint:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	self:_create()
	ElementInstancePoint.super.on_executed(self, instigator)
end

-- Lines 129-157
function ElementInstancePoint:_create()
	if self._has_created then
		if Application:editor() then
			managers.editor:output_error("[ElementInstancePoint:_create()] Attempted to double-spawn a spawned instance [" .. self._editor_name .. "]")
		end

		return
	end

	self._has_created = true

	if Network:is_server() then
		self._mission_script:add_save_state_cb(self._id)
	end

	if self._values.instance then
		local pos, rot = self:get_orientation()

		managers.world_instance:custom_create_instance(self._values.instance, {
			position = pos,
			rotation = rot
		})
	elseif Application:editor() then
		managers.editor:output_error("[ElementInstancePoint:_create()] No instance defined in [" .. self._editor_name .. "]")
	end
end

-- Lines 160-166
function ElementInstancePoint:save(data)
	data.has_created = self._has_created
end

-- Lines 169-177
function ElementInstancePoint:load(data)
	if data.has_created then
		self:_create()
	end
end

ElementInstanceParams = ElementInstanceParams or class(CoreMissionScriptElement.MissionScriptElement)
ElementInstanceSetParams = ElementInstanceSetParams or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 186-192
function ElementInstanceSetParams:init(...)
	ElementInstanceOutputEvent.super.init(self, ...)

	if not self._values.apply_on_execute then
		self:_apply_instance_params()
	end
end

-- Lines 195-197
function ElementInstanceSetParams:client_on_executed(...)
	self:on_executed(...)
end

-- Lines 200-206
function ElementInstanceSetParams:_apply_instance_params()
	if self._values.instance then
		managers.world_instance:set_instance_params(self._values.instance, self._values.params)
	elseif Application:editor() then
		managers.editor:output_error("[ElementInstanceSetParams:_apply_instance_params()] No instance defined in [" .. self._editor_name .. "]")
	end
end

-- Lines 209-220
function ElementInstanceSetParams:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if self._values.apply_on_execute then
		self:_apply_instance_params()
	end

	ElementInstanceSetParams.super.on_executed(self, instigator)
end
