require("core/lib/setups/CoreLoadingSetup")
require("lib/utils/LightLoadingScreenGuiScript")

LightLoadingSetup = LightLoadingSetup or class(CoreLoadingSetup)

-- Lines: 21 to 33
function LightLoadingSetup:init()
	self._camera = Scene:create_camera()

	LoadingViewport:set_camera(self._camera)

	self._gui_wrapper = LightLoadingScreenGuiScript:new(Scene:gui(), arg.res, -1, arg.layer, arg.is_win32)
end

-- Lines: 41 to 43
function LightLoadingSetup:update(t, dt)
	self._gui_wrapper:update(-1, dt)
end

-- Lines: 45 to 48
function LightLoadingSetup:destroy()
	LightLoadingSetup.super.destroy(self)
	Scene:delete_camera(self._camera)
end
setup = setup or LightLoadingSetup:new()

setup:make_entrypoint()

