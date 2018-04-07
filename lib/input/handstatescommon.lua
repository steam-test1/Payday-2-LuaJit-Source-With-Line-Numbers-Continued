HandStatesCommon = HandStatesCommon or {}
local M = HandStatesCommon

-- Lines: 4 to 13
function M.warp_inputs()
	local inputs = {}

	table.insert(inputs, "trackpad_button_")

	if managers.vr:is_oculus() then
		if not managers.vr:walking_mode() then
			table.insert(inputs, "d_up_")
		end

		table.insert(inputs, "b_")
	end

	return inputs
end

-- Lines: 16 to 22
function M.warp_target_inputs()
	local inputs = {}

	table.insert(inputs, "trackpad_button_")

	if managers.vr:is_oculus() then
		table.insert(inputs, "b_")
	end

	return inputs
end

-- Lines: 25 to 32
function M.run_input()
	local inputs = {}

	if managers.vr:walking_mode() then
		table.insert(inputs, "trackpad_button_")
	end

	return inputs
end

-- Lines: 36 to 44
function M:toggle_menu_condition(hand, key_map)
	for key, connections in pairs(key_map) do
		if table.contains(connections, "toggle_menu") then
			return false
		end
	end

	local default_hand = managers.vr:get_setting("default_weapon_hand") == "right" and 1 or 2

	return hand == default_hand
end

-- Lines: 47 to 59
function M:movement_condition(hand, key_map, connection_name)
	local default_hand = managers.vr:get_setting("default_weapon_hand") == "right" and 1 or 2

	for key, connections in pairs(key_map) do
		if table.contains(connections, connection_name) then
			if hand == default_hand then
				return false
			else
				return "exclusive"
			end
		end
	end

	return true
end

return M
