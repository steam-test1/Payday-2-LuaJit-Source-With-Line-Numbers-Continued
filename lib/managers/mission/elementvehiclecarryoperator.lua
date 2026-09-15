ElementVehicleCarryOperator = ElementVehicleCarryOperator or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 4-6
function ElementVehicleCarryOperator:init(...)
	ElementVehicleCarryOperator.super.init(self, ...)
end

-- Lines 9-11
function ElementVehicleCarryOperator:client_on_executed(...)
	self:on_executed(...)
end

-- Lines 14-20
function ElementVehicleCarryOperator:_get_unit(unit_id)
	if Global.running_simulation then
		return managers.editor:unit_with_id(unit_id)
	else
		return managers.worlddefinition:get_unit(unit_id)
	end
end

-- Lines 23-57
function ElementVehicleCarryOperator:_apply_carry_operation(unit)
	local operation_id = self._values.operation

	if operation_id == "none" then
		Application:warn("Vehicle Carry Operator applied but operation is set to 'none'")

		return
	end

	if unit then
		local extension = unit:npc_vehicle_driving() or unit:vehicle_driving()

		if extension then
			if operation_id == "override" then
				extension:clear_carry_filter_items()
			end

			if operation_id == "add" or operation_id == "override" then
				extension:set_carry_filter_items(self._values.carry_ids, true)
			elseif operation_id == "remove" then
				extension:set_carry_filter_items(self._values.carry_ids, false)
			end
		else
			Application:error("Vehicle Operator applied to a unit that isn't a vehicle: ", inspect(unit))
		end
	else
		Application:warn("Vehicle Operator applied to a unit that doesn't exist - operator: ", inspect(self._unit))
	end
end

-- Lines 60-78
function ElementVehicleCarryOperator:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if self._values.use_instigator then
		if instigator then
			self:_apply_carry_operation(instigator)
		end
	else
		for _, id in ipairs(self._values.elements) do
			local unit = self:_get_unit(id)

			self:_apply_carry_operation(unit)
		end
	end

	ElementVehicleCarryOperator.super.on_executed(self, instigator)
end
