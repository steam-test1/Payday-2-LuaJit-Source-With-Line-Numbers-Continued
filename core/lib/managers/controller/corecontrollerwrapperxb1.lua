core:module("CoreControllerWrapperXB1")
core:import("CoreControllerWrapper")

ControllerWrapperXB1 = ControllerWrapperXB1 or class(CoreControllerWrapper.ControllerWrapper)
ControllerWrapperXB1.TYPE = "xb1"
ControllerWrapperXB1.CONTROLLER_TYPE_LIST = {
	"xb1_controller"
}

-- Lines 9-16
function ControllerWrapperXB1:init(manager, id, name, controller, setup, debug, skip_virtual_controller)
	local func_map = {
		confirm = callback(self, self, "virtual_connect_confirm"),
		cancel = callback(self, self, "virtual_connect_cancel")
	}

	ControllerWrapperXB1.super.init(self, manager, id, name, {
		xb1pad = controller
	}, "xb1pad", setup, debug, skip_virtual_controller, {
		xb1pad = func_map
	})
end

-- Lines 18-20
function ControllerWrapperXB1:virtual_connect_confirm(controller_id, controller, input_name, connection_name, connection)
	self:virtual_connect2(controller_id, controller, "a", connection_name, connection)
end

-- Lines 22-24
function ControllerWrapperXB1:virtual_connect_cancel(controller_id, controller, input_name, connection_name, connection)
	self:virtual_connect2(controller_id, controller, "b", connection_name, connection)
end
