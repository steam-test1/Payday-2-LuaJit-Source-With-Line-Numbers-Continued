CoreScriptUnitData = CoreScriptUnitData or class()
CoreScriptUnitData.world_pos = Vector3(0, 0, 0)
CoreScriptUnitData.local_pos = Vector3(0, 0, 0)
CoreScriptUnitData.local_rot = Rotation(0, 0, 0)
CoreScriptUnitData.unit_id = 0
CoreScriptUnitData.name_id = "none"
CoreScriptUnitData.mesh_variation = nil
CoreScriptUnitData.material = nil
CoreScriptUnitData.unique_item = false
CoreScriptUnitData.only_exists_in_editor = false
CoreScriptUnitData.only_visible_in_editor = false
CoreScriptUnitData.editable_gui = false
CoreScriptUnitData.editable_gui_text = "Default"
CoreScriptUnitData.portal_visible_inverse = false
CoreScriptUnitData.exists_in_stages = {
	true,
	true,
	true,
	true,
	true,
	true
}
CoreScriptUnitData.helper_type = "none"
CoreScriptUnitData.disable_shadows = nil
CoreScriptUnitData.disable_collision = nil
CoreScriptUnitData.delayed_load = nil
CoreScriptUnitData.hide_on_projection_light = nil
CoreScriptUnitData.disable_on_ai_graph = nil

if Application:editor() then
	-- Lines 26-30
	function CoreScriptUnitData:init(unit)
		self.unit_groups = {}

		unit:set_extension_update_enabled(Idstring("unit_data"), false)
	end
else
	-- Lines 32-34
	function CoreScriptUnitData:init(unit)
		unit:set_extension_update_enabled(Idstring("unit_data"), false)
	end
end
