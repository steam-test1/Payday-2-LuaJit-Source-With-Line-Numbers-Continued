core:import("CoreMissionScriptElement")

ElementAlertTrigger = ElementAlertTrigger or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-16
function ElementAlertTrigger:init(...)
	ElementAlertTrigger.super.init(self, ...)

	self._values.filter = self._values.filter or "0"
	self._values.alert_types = self._values.alert_types or {}
	self._filter = managers.navigation:convert_access_filter_to_number(self._values.filter)
	self._alert_types_map = {}

	for _, alert_type in ipairs(self._values.alert_types) do
		self._alert_types_map[alert_type] = true
	end
end

-- Lines 18-20
function ElementAlertTrigger:client_on_executed(...)
end

-- Lines 22-24
function ElementAlertTrigger:on_executed(instigator)
	ElementAlertTrigger.super.on_executed(self, instigator)
end

-- Lines 26-32
function ElementAlertTrigger:do_synced_execute(instigator)
	if Network:is_server() then
		self:on_executed(instigator)
	else
		managers.network:session():send_to_host("to_server_mission_element_trigger", self._id, instigator)
	end
end

-- Lines 34-40
function ElementAlertTrigger:operation_add()
	if self._added then
		return
	end

	self._added = true

	managers.groupai:state():add_alert_listener(self._id, callback(self, self, "on_alert"), self._filter, self._alert_types_map, self._values.position)
end

-- Lines 42-48
function ElementAlertTrigger:operation_remove()
	if not self._added then
		return
	end

	self._added = nil

	managers.groupai:state():remove_alert_listener(self._id)
end

-- Lines 50-53
function ElementAlertTrigger:on_alert(alert_data)
	local instigator = alert_data[5]

	self:do_synced_execute(instigator)
end
