core:module("CoreMenuItem")

Item = Item or class()
Item.TYPE = "item"

-- Lines 6-78
function Item:init(data_node, parameters)
	self._type = ""
	local params = parameters or {}
	params.info_panel = ""

	if data_node then
		for key, value in pairs(data_node) do
			if key ~= "_meta" and type(value) ~= "table" then
				params[key] = value
			end
		end
	end

	local required_params = {
		"name"
	}

	for _, p_name in ipairs(required_params) do
		if not params[p_name] then
			Application:error("Menu item without parameter '" .. p_name .. "'")
		end
	end

	if params.visible_callback then
		self._visible_callback_name_list = string.split(params.visible_callback, " ")
	end

	if params.enabled_callback then
		self._enabled_callback_name_list = string.split(params.enabled_callback, " ")
	end

	if params.icon_visible_callback then
		self._icon_visible_callback_name_list = string.split(params.icon_visible_callback, " ")
	end

	if params.glow_visible_callback then
		self._glow_visible_callback_name_list = string.split(params.glow_visible_callback, " ")
	end

	if params.callback then
		params.callback = string.split(params.callback, " ")
	else
		params.callback = {}
	end

	if params.callback then
		params.callback_name = params.callback
		params.callback = {}
	end

	if params.callback_disabled then
		params.callback_disabled = string.split(params.callback_disabled, " ")
	else
		params.callback_disabled = {}
	end

	if params.callback_disabled then
		params.callback_disabled_name = params.callback_disabled
		params.callback_disabled = {}
	end

	self:set_parameters(params)

	self._enabled = true
end

-- Lines 80-83
function Item:set_enabled(enabled)
	self._enabled = enabled

	self:dirty()
end

-- Lines 85-87
function Item:enabled()
	return self._enabled
end

-- Lines 89-91
function Item:type()
	return self._type
end

-- Lines 93-95
function Item:name()
	return self._parameters.name
end

-- Lines 97-99
function Item:info_panel()
	return self._parameters.info_panel
end

-- Lines 101-103
function Item:parameters()
	return self._parameters
end

-- Lines 105-107
function Item:parameter(name)
	return self._parameters[name]
end

-- Lines 109-111
function Item:set_parameter(name, value)
	self._parameters[name] = value
end

-- Lines 113-115
function Item:set_parameters(parameters)
	self._parameters = parameters
end

-- Lines 117-157
function Item:set_callback_handler(callback_handler)
	self._callback_handler = callback_handler

	for _, callback_name in pairs(self._parameters.callback_name) do
		table.insert(self._parameters.callback, callback(callback_handler, callback_handler, callback_name))
	end

	for _, callback_name in pairs(self._parameters.callback_disabled_name) do
		table.insert(self._parameters.callback_disabled, callback(callback_handler, callback_handler, callback_name))
	end

	if self._visible_callback_name_list then
		for _, visible_callback_name in pairs(self._visible_callback_name_list) do
			self._visible_callback_list = self._visible_callback_list or {}

			table.insert(self._visible_callback_list, callback(callback_handler, callback_handler, visible_callback_name))
		end
	end

	if self._icon_visible_callback_name_list then
		for _, visible_callback_name in pairs(self._icon_visible_callback_name_list) do
			self._icon_visible_callback_list = self._icon_visible_callback_list or {}

			table.insert(self._icon_visible_callback_list, callback(callback_handler, callback_handler, visible_callback_name))
		end
	end

	if self._glow_visible_callback_name_list then
		for _, visible_callback_name in pairs(self._glow_visible_callback_name_list) do
			self._glow_visible_callback_list = self._glow_visible_callback_list or {}

			table.insert(self._glow_visible_callback_list, callback(callback_handler, callback_handler, visible_callback_name))
		end
	end

	if self._enabled_callback_name_list then
		for _, enabled_callback_name in pairs(self._enabled_callback_name_list) do
			if callback_handler[enabled_callback_name] then
				if not callback_handler[enabled_callback_name](self) then
					self:set_enabled(false)

					break
				end
			else
				Application:error("[Item:set_callback_handler] inexistent callback:", enabled_callback_name)
			end
		end
	end
end

-- Lines 159-163
function Item:trigger()
	for _, callback in pairs((self:enabled() or self:parameters().ignore_disabled) and self:parameters().callback or self:parameters().callback_disabled) do
		callback(self)
	end
end

-- Lines 165-169
function Item:dirty()
	if self.dirty_callback then
		self:dirty_callback()
	end
end

-- Lines 171-173
function Item:set_visible(visible)
	self._visible = visible
end

-- Lines 175-187
function Item:visible()
	if self._visible == false then
		return false
	end

	if self._visible_callback_list then
		for _, visible_callback in pairs(self._visible_callback_list) do
			if not visible_callback(self) then
				return false
			end
		end
	end

	return true
end

-- Lines 189-191
function Item:on_delete_row_item()
end

-- Lines 193-199
function Item:on_delete_item()
	self._parameters.callback = {}
	self._parameters.callback_disabled = {}
	self._visible_callback_list = nil
	self._icon_visible_callback_list = nil
	self._glow_visible_callback_list = nil
end

-- Lines 201-202
function Item:on_item_position(row_item, node)
end

-- Lines 204-205
function Item:on_item_positions_done(row_item, node)
end

-- Lines 207-209
function Item:get_h(row_item)
	return nil
end

-- Lines 215-217
function Item:setup_gui(node, row_item)
	return false
end

-- Lines 220-222
function Item:reload(row_item)
	return false
end

-- Lines 225-227
function Item:highlight_row_item(node, row_item, mouse_over)
	return false
end

-- Lines 230-232
function Item:fade_row_item(node, row_item)
	return false
end

-- Lines 234-236
function Item:menu_unselected_visible()
	return true
end

-- Lines 238-247
function Item:icon_visible()
	if self._icon_visible_callback_list then
		for _, visible_callback in pairs(self._icon_visible_callback_list) do
			if not visible_callback(self) then
				return false
			end
		end
	end

	return true
end

-- Lines 249-258
function Item:glow_visible()
	if self._glow_visible_callback_list then
		for _, visible_callback in pairs(self._glow_visible_callback_list) do
			if not visible_callback(self) then
				return false
			end
		end
	end

	return true
end
