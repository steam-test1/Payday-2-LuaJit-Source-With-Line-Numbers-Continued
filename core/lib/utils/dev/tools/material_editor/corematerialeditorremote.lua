CoreMaterialEditorRemote = CoreMaterialEditorRemote or class()
CoreMaterialEditorRemote.PORT = 11332
CoreMaterialEditorRemote.TEMP_PATH = "core/temp/"

-- Lines: 6 to 8
function CoreMaterialEditorRemote:init()
	Network:bind(self.PORT, self)
end

-- Lines: 10 to 29
function CoreMaterialEditorRemote:reload_shader_libs()
	Application:update_filesystem_index(self.TEMP_PATH .. "temp_rt.xml")
	Application:load_render_templates(self.TEMP_PATH .. "temp_rt.xml")

	if SystemInfo:platform() == "WIN32" then
		if SystemInfo:renderer() == "DX10" then
			Application:update_filesystem_index(self.TEMP_PATH .. "temp_lib_win32dx10.diesel")
			Application:load_shader_config(self.TEMP_PATH .. "temp_lib_win32dx10")
		else
			Application:update_filesystem_index(self.TEMP_PATH .. "temp_lib_win32dx9.diesel")
			Application:load_shader_config(self.TEMP_PATH .. "temp_lib_win32dx9")
		end
	elseif SystemInfo:platform() == "X360" then
		Application:update_filesystem_index(self.TEMP_PATH .. "temp_lib_x360.diesel")
		Application:load_shader_config(self.TEMP_PATH .. "temp_lib_x360")
	else
		Application:update_filesystem_index(self.TEMP_PATH .. "temp_lib_ps3.diesel")
		Application:load_shader_config(self.TEMP_PATH .. "temp_lib_ps3")
	end
end

return
