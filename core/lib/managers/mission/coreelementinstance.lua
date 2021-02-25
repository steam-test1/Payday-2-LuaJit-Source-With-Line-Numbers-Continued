core:module("CoreElementInstance")
core:import("CoreMissionScriptElement")

ElementInstanceInput = ElementInstanceInput or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 6-16
function ElementInstanceInput:init(...)
	ElementInstanceInput.super.init(self, ...)

	if self._values.instance_name then
		managers.world_instance:register_input_element(self._values.instance_name, self._values.event, self)
	end
end

-- Lines 18-20
function ElementInstanceInput:client_on_executed(...)
end

-- Lines 22-30
function ElementInstanceInput:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementInstanceInput.super.on_executed(self, instigator)
end

ElementInstanceOutput = ElementInstanceOutput or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 36-40
function ElementInstanceOutput:init(...)
	ElementInstanceOutput.super.init(self, ...)
end

-- Lines 42-45
function ElementInstanceOutput:on_created()
	self._output_elements = managers.world_instance:get_registered_output_event_elements(self._values.instance_name, self._values.event)
end

-- Lines 47-49
function ElementInstanceOutput:client_on_executed(...)
end

-- Lines 51-63
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

-- Lines 69-71
function ElementInstanceInputEvent:init(...)
	ElementInstanceInputEvent.super.init(self, ...)
end

-- Lines 73-77
function ElementInstanceInputEvent:on_created()
end

-- Lines 79-81
function ElementInstanceInputEvent:client_on_executed(...)
end

-- Lines 83-108
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

-- Lines 114-126
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

-- Lines 128-130
function ElementInstanceOutputEvent:client_on_executed(...)
end

-- Lines 132-140
function ElementInstanceOutputEvent:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementInstanceOutputEvent.super.on_executed(self, instigator)
end

ElementInstancePoint = ElementInstancePoint or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 146-148
function ElementInstancePoint:client_on_executed(...)
end

-- Lines 150-159
function ElementInstancePoint:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	self:_create()
	ElementInstancePoint.super.on_executed(self, instigator)
end

-- Lines 161-174
function ElementInstancePoint:_create()
	if self._has_created then
		return
	end

	self._has_created = true

	if Network:is_server() then
		self._mission_script:add_save_state_cb(self._id)
	end

	if self._values.instance then
		managers.world_instance:custom_create_instance(self._values.instance, {
			position = self._values.position,
			rotation = self._values.rotation
		})
	elseif Application:editor() then
		managers.editor:output_error("[ElementInstancePoint:_create()] No instance defined in [" .. self._editor_name .. "]")
	end
end

-- Lines 177-179
function ElementInstancePoint:save(data)
	data.has_created = self._has_created
end

-- Lines 181-185
function ElementInstancePoint:load(data)
	if data.has_created then
		self:_create()
	end
end

ElementInstanceParams = ElementInstanceParams or class(CoreMissionScriptElement.MissionScriptElement)
ElementInstanceSetParams = ElementInstanceSetParams or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 196-202
function ElementInstanceSetParams:init(...)
	ElementInstanceOutputEvent.super.init(self, ...)

	if not self._values.apply_on_execute then
		self:_apply_instance_params()
	end
end

-- Lines 204-206
function ElementInstanceSetParams:client_on_executed(...)
	self:on_executed(...)
end

-- Lines 208-214
function ElementInstanceSetParams:_apply_instance_params()
	if self._values.instance then
		managers.world_instance:set_instance_params(self._values.instance, self._values.params)
	elseif Application:editor() then
		managers.editor:output_error("[ElementInstanceSetParams:_apply_instance_params()] No instance defined in [" .. self._editor_name .. "]")
	end
end

-- Lines 216-227
function ElementInstanceSetParams:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if self._values.apply_on_execute then
		self:_apply_instance_params()
	end

	ElementInstanceSetParams.super.on_executed(self, instigator)
end
