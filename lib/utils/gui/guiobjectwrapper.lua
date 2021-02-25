GUIObjectWrapper = GUIObjectWrapper or class()

-- Lines 3-5
function GUIObjectWrapper:init(gui_obj)
	self._gui_obj = gui_obj
end

-- Lines 7-7
function GUIObjectWrapper:bottom(...)
	return self._gui_obj:bottom(...)
end

-- Lines 8-8
function GUIObjectWrapper:center(...)
	return self._gui_obj:center(...)
end

-- Lines 9-9
function GUIObjectWrapper:center_x(...)
	return self._gui_obj:center_x(...)
end

-- Lines 10-10
function GUIObjectWrapper:center_y(...)
	return self._gui_obj:center_y(...)
end

-- Lines 11-11
function GUIObjectWrapper:h(...)
	return self._gui_obj:h(...)
end

-- Lines 12-12
function GUIObjectWrapper:height(...)
	return self._gui_obj:height(...)
end

-- Lines 13-13
function GUIObjectWrapper:left(...)
	return self._gui_obj:left(...)
end

-- Lines 14-14
function GUIObjectWrapper:leftbottom(...)
	return self._gui_obj:leftbottom(...)
end

-- Lines 15-15
function GUIObjectWrapper:lefttop(...)
	return self._gui_obj:lefttop(...)
end

-- Lines 16-16
function GUIObjectWrapper:position(...)
	return self._gui_obj:position(...)
end

-- Lines 17-17
function GUIObjectWrapper:right(...)
	return self._gui_obj:right(...)
end

-- Lines 18-18
function GUIObjectWrapper:rightbottom(...)
	return self._gui_obj:rightbottom(...)
end

-- Lines 19-19
function GUIObjectWrapper:righttop(...)
	return self._gui_obj:righttop(...)
end

-- Lines 20-20
function GUIObjectWrapper:size(...)
	return self._gui_obj:size(...)
end

-- Lines 21-21
function GUIObjectWrapper:top(...)
	return self._gui_obj:top(...)
end

-- Lines 22-22
function GUIObjectWrapper:w(...)
	return self._gui_obj:w(...)
end

-- Lines 23-23
function GUIObjectWrapper:width(...)
	return self._gui_obj:width(...)
end

-- Lines 24-24
function GUIObjectWrapper:world_bottom(...)
	return self._gui_obj:world_bottom(...)
end

-- Lines 25-25
function GUIObjectWrapper:world_center(...)
	return self._gui_obj:world_center(...)
end

-- Lines 26-26
function GUIObjectWrapper:world_center_x(...)
	return self._gui_obj:world_center_x(...)
end

-- Lines 27-27
function GUIObjectWrapper:world_center_y(...)
	return self._gui_obj:world_center_y(...)
end

-- Lines 28-28
function GUIObjectWrapper:world_left(...)
	return self._gui_obj:world_left(...)
end

-- Lines 29-29
function GUIObjectWrapper:world_leftbottom(...)
	return self._gui_obj:world_leftbottom(...)
end

-- Lines 30-30
function GUIObjectWrapper:world_lefttop(...)
	return self._gui_obj:world_lefttop(...)
end

-- Lines 31-31
function GUIObjectWrapper:world_position(...)
	return self._gui_obj:world_position(...)
end

-- Lines 32-32
function GUIObjectWrapper:world_right(...)
	return self._gui_obj:world_right(...)
end

-- Lines 33-33
function GUIObjectWrapper:world_rightbottom(...)
	return self._gui_obj:world_rightbottom(...)
end

-- Lines 34-34
function GUIObjectWrapper:world_righttop(...)
	return self._gui_obj:world_righttop(...)
end

-- Lines 35-35
function GUIObjectWrapper:world_top(...)
	return self._gui_obj:world_top(...)
end

-- Lines 36-36
function GUIObjectWrapper:world_x(...)
	return self._gui_obj:world_x(...)
end

-- Lines 37-37
function GUIObjectWrapper:world_y(...)
	return self._gui_obj:world_y(...)
end

-- Lines 38-38
function GUIObjectWrapper:x(...)
	return self._gui_obj:x(...)
end

-- Lines 39-39
function GUIObjectWrapper:y(...)
	return self._gui_obj:y(...)
end

-- Lines 41-41
function GUIObjectWrapper:set_bottom(...)
	self._gui_obj:set_bottom(...)
end

-- Lines 42-42
function GUIObjectWrapper:set_center(...)
	self._gui_obj:set_center(...)
end

-- Lines 43-43
function GUIObjectWrapper:set_center_x(...)
	self._gui_obj:set_center_x(...)
end

-- Lines 44-44
function GUIObjectWrapper:set_center_y(...)
	self._gui_obj:set_center_y(...)
end

-- Lines 45-45
function GUIObjectWrapper:set_debug(...)
	self._gui_obj:set_debug(...)
end

-- Lines 46-46
function GUIObjectWrapper:set_h(...)
	self._gui_obj:set_h(...)
end

-- Lines 47-47
function GUIObjectWrapper:set_height(...)
	self._gui_obj:set_height(...)
end

-- Lines 48-48
function GUIObjectWrapper:set_left(...)
	self._gui_obj:set_left(...)
end

-- Lines 49-49
function GUIObjectWrapper:set_leftbottom(...)
	self._gui_obj:set_leftbottom(...)
end

-- Lines 50-50
function GUIObjectWrapper:set_lefttop(...)
	self._gui_obj:set_lefttop(...)
end

-- Lines 51-51
function GUIObjectWrapper:set_position(...)
	self._gui_obj:set_position(...)
end

-- Lines 52-52
function GUIObjectWrapper:set_right(...)
	self._gui_obj:set_right(...)
end

-- Lines 53-53
function GUIObjectWrapper:set_rightbottom(...)
	self._gui_obj:set_rightbottom(...)
end

-- Lines 54-54
function GUIObjectWrapper:set_righttop(...)
	self._gui_obj:set_righttop(...)
end

-- Lines 55-55
function GUIObjectWrapper:set_size(...)
	self._gui_obj:set_size(...)
end

-- Lines 56-56
function GUIObjectWrapper:set_top(...)
	self._gui_obj:set_top(...)
end

-- Lines 57-57
function GUIObjectWrapper:set_w(...)
	self._gui_obj:set_w(...)
end

-- Lines 58-58
function GUIObjectWrapper:set_width(...)
	self._gui_obj:set_width(...)
end

-- Lines 59-59
function GUIObjectWrapper:set_world_bottom(...)
	self._gui_obj:set_world_bottom(...)
end

-- Lines 60-60
function GUIObjectWrapper:set_world_center(...)
	self._gui_obj:set_world_center(...)
end

-- Lines 61-61
function GUIObjectWrapper:set_world_center_x(...)
	self._gui_obj:set_world_center_x(...)
end

-- Lines 62-62
function GUIObjectWrapper:set_world_center_y(...)
	self._gui_obj:set_world_center_y(...)
end

-- Lines 63-63
function GUIObjectWrapper:set_world_left(...)
	self._gui_obj:set_world_left(...)
end

-- Lines 64-64
function GUIObjectWrapper:set_world_leftbottom(...)
	self._gui_obj:set_world_leftbottom(...)
end

-- Lines 65-65
function GUIObjectWrapper:set_world_lefttop(...)
	self._gui_obj:set_world_lefttop(...)
end

-- Lines 66-66
function GUIObjectWrapper:set_world_position(...)
	self._gui_obj:set_world_position(...)
end

-- Lines 67-67
function GUIObjectWrapper:set_world_right(...)
	self._gui_obj:set_world_right(...)
end

-- Lines 68-68
function GUIObjectWrapper:set_world_rightbottom(...)
	self._gui_obj:set_world_rightbottom(...)
end

-- Lines 69-69
function GUIObjectWrapper:set_world_righttop(...)
	self._gui_obj:set_world_righttop(...)
end

-- Lines 70-70
function GUIObjectWrapper:set_world_top(...)
	self._gui_obj:set_world_top(...)
end

-- Lines 71-71
function GUIObjectWrapper:set_world_x(...)
	self._gui_obj:set_world_x(...)
end

-- Lines 72-72
function GUIObjectWrapper:set_world_y(...)
	self._gui_obj:set_world_y(...)
end

-- Lines 73-73
function GUIObjectWrapper:set_x(...)
	self._gui_obj:set_x(...)
end

-- Lines 74-74
function GUIObjectWrapper:set_y(...)
	self._gui_obj:set_y(...)
end

-- Lines 76-76
function GUIObjectWrapper:set_visible(...)
	self._gui_obj:set_visible(...)
end

-- Lines 77-77
function GUIObjectWrapper:set_valign(...)
	self._gui_obj:set_valign(...)
end

-- Lines 78-78
function GUIObjectWrapper:set_halign(...)
	self._gui_obj:set_halign(...)
end

-- Lines 80-80
function GUIObjectWrapper:move(...)
	self._gui_obj:move(...)
end

-- Lines 81-81
function GUIObjectWrapper:grow(...)
	self._gui_obj:grow(...)
end

-- Lines 83-83
function GUIObjectWrapper:animate(...)
	return self._gui_obj:animate(...)
end

-- Lines 85-85
function GUIObjectWrapper:layer(...)
	return self._gui_obj:layer(...)
end

-- Lines 86-86
function GUIObjectWrapper:set_layer(...)
	self._gui_obj:set_layer(...)
end

-- Lines 87-87
function GUIObjectWrapper:set_world_layer(...)
	self._gui_obj:set_world_layer(...)
end

-- Lines 88-88
function GUIObjectWrapper:world_layer(...)
	return self._gui_obj:world_layer(...)
end

-- Lines 90-90
function GUIObjectWrapper:inside(...)
	return self._gui_obj:inside(...)
end

-- Lines 91-91
function GUIObjectWrapper:outside(...)
	return self._gui_obj:outside(...)
end

-- Lines 93-93
function GUIObjectWrapper:alive(...)
	return self._gui_obj:alive(...)
end
