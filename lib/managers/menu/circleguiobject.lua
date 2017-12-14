CircleGuiObject = CircleGuiObject or class()

-- Lines: 12 to 34
function CircleGuiObject:init(panel, config)
	self._panel = panel
	self._radius = config.radius or 20
	self._sides = config.sides or 10
	self._total = config.total or 1
	config.triangles = self:_create_triangles(config)
	config.w = self._radius * 2
	config.h = self._radius * 2
	self._circle = self._panel:polygon(config)
end

-- Lines: 36 to 49
function CircleGuiObject:_create_triangles(config)
	local amount = (360 * (config.current or 1)) / (config.total or 1)
	local s = self._radius
	local triangles = {}
	local step = 360 / self._sides

	for i = step, amount, step do
		local mid = Vector3(self._radius, self._radius, 0)

		table.insert(triangles, mid)
		table.insert(triangles, mid + Vector3(math.sin(i) * self._radius, -math.cos(i) * self._radius, 0))
		table.insert(triangles, mid + Vector3(math.sin(i - step) * self._radius, -math.cos(i - step) * self._radius, 0))
	end

	return triangles
end

-- Lines: 52 to 56
function CircleGuiObject:set_current(current)
	local triangles = self:_create_triangles({
		current = current,
		total = self._total
	})

	self._circle:clear()
	self._circle:add_triangles(triangles)
end

-- Lines: 58 to 60
function CircleGuiObject:set_position(x, y)
	self._circle:set_position(x, y)
end

-- Lines: 62 to 66
function CircleGuiObject:set_align(h, v)
	v = v or h

	self._circle:set_halign(h)
	self._circle:set_valign(v)
end

-- Lines: 68 to 70
function CircleGuiObject:set_layer(layer)
	self._circle:set_layer(layer)
end

-- Lines: 72 to 73
function CircleGuiObject:layer()
	return self._circle:layer()
end

-- Lines: 76 to 78
function CircleGuiObject:remove()
	self._panel:remove(self._circle)
end
CircleBitmapGuiObject = CircleBitmapGuiObject or class()

-- Lines: 84 to 108
function CircleBitmapGuiObject:init(panel, config)
	self._panel = panel
	self._radius = config.radius or 20
	self._sides = config.sides or 64
	self._total = config.total or 1
	self._size = 128
	config.texture_rect = nil
	config.texture = config.image or "guis/textures/pd2/hud_progress_active"
	config.w = self._radius * 2
	config.h = self._radius * 2
	self._circle = self._panel:bitmap(config)

	self._circle:set_render_template(Idstring("VertexColorTexturedRadial"))

	self._alpha = self._circle:color().alpha

	self._circle:set_color(self._circle:color():with_red(0))

	if config.use_bg then
		local bg_config = deep_clone(config)
		bg_config.texture = config.bg or "guis/textures/pd2/hud_progress_bg"
		bg_config.layer = bg_config.layer - 1
		bg_config.blend_mode = "normal"
		self._bg_circle = self._panel:bitmap(bg_config)
	end
end

-- Lines: 110 to 111
function CircleBitmapGuiObject:radius()
	return self._radius
end

-- Lines: 114 to 120
function CircleBitmapGuiObject:set_current(current)
	local j = math.mod(math.floor(current), 8)
	local i = math.floor(current / 8)

	self._circle:set_color(Color(self._alpha, current, self._circle:color().blue, self._circle:color().green))
end

-- Lines: 122 to 123
function CircleBitmapGuiObject:position()
	return self._circle:position()
end

-- Lines: 126 to 134
function CircleBitmapGuiObject:set_align(h, v)
	v = v or h

	self._circle:set_halign(h)
	self._circle:set_valign(v)

	if self._bg_circle then
		self._bg_circle:set_halign(h)
		self._bg_circle:set_valign(v)
	end
end

-- Lines: 136 to 141
function CircleBitmapGuiObject:set_position(x, y)
	self._circle:set_position(x, y)

	if self._bg_circle then
		self._bg_circle:set_position(x, y)
	end
end

-- Lines: 143 to 148
function CircleBitmapGuiObject:set_visible(visible)
	self._circle:set_visible(visible)

	if self._bg_circle then
		self._bg_circle:set_visible(visible)
	end
end

-- Lines: 150 to 151
function CircleBitmapGuiObject:visible()
	return self._circle:visible()
end

-- Lines: 154 to 156
function CircleBitmapGuiObject:set_alpha(alpha)
	self._circle:set_alpha(alpha)
end

-- Lines: 158 to 160
function CircleBitmapGuiObject:alpha()
	self._circle:alpha()
end

-- Lines: 162 to 164
function CircleBitmapGuiObject:set_color(color)
	self._circle:set_color(color)
end

-- Lines: 166 to 167
function CircleBitmapGuiObject:color()
	return self._circle:color()
end

-- Lines: 170 to 171
function CircleBitmapGuiObject:size()
	return self._circle:size()
end

-- Lines: 174 to 176
function CircleBitmapGuiObject:set_image(texture)
	self._circle:set_image(texture)
end

-- Lines: 178 to 183
function CircleBitmapGuiObject:set_layer(layer)
	self._circle:set_layer(layer)

	if self._bg_circle then
		self._bg_circle:set_layer(layer - 1)
	end
end

-- Lines: 185 to 186
function CircleBitmapGuiObject:layer()
	return self._circle:layer()
end

-- Lines: 189 to 195
function CircleBitmapGuiObject:remove()
	self._panel:remove(self._circle)

	if self._bg_circle then
		self._panel:remove(self._bg_circle)
	end

	self._panel = nil
end

