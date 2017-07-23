GUIObjectWrapper = GUIObjectWrapper or class()

-- Lines: 3 to 5
function GUIObjectWrapper:init(gui_obj)
	self._gui_obj = gui_obj
end

-- Lines: 6 to 7
function GUIObjectWrapper:bottom(...)
	return self._gui_obj:bottom(...)
end

-- Lines: 7 to 8
function GUIObjectWrapper:center(...)
	return self._gui_obj:center(...)
end

-- Lines: 8 to 9
function GUIObjectWrapper:center_x(...)
	return self._gui_obj:center_x(...)
end

-- Lines: 9 to 10
function GUIObjectWrapper:center_y(...)
	return self._gui_obj:center_y(...)
end

-- Lines: 10 to 11
function GUIObjectWrapper:h(...)
	return self._gui_obj:h(...)
end

-- Lines: 11 to 12
function GUIObjectWrapper:height(...)
	return self._gui_obj:height(...)
end

-- Lines: 12 to 13
function GUIObjectWrapper:left(...)
	return self._gui_obj:left(...)
end

-- Lines: 13 to 14
function GUIObjectWrapper:leftbottom(...)
	return self._gui_obj:leftbottom(...)
end

-- Lines: 14 to 15
function GUIObjectWrapper:lefttop(...)
	return self._gui_obj:lefttop(...)
end

-- Lines: 15 to 16
function GUIObjectWrapper:position(...)
	return self._gui_obj:position(...)
end

-- Lines: 16 to 17
function GUIObjectWrapper:right(...)
	return self._gui_obj:right(...)
end

-- Lines: 17 to 18
function GUIObjectWrapper:rightbottom(...)
	return self._gui_obj:rightbottom(...)
end

-- Lines: 18 to 19
function GUIObjectWrapper:righttop(...)
	return self._gui_obj:righttop(...)
end

-- Lines: 19 to 20
function GUIObjectWrapper:size(...)
	return self._gui_obj:size(...)
end

-- Lines: 20 to 21
function GUIObjectWrapper:top(...)
	return self._gui_obj:top(...)
end

-- Lines: 21 to 22
function GUIObjectWrapper:w(...)
	return self._gui_obj:w(...)
end

-- Lines: 22 to 23
function GUIObjectWrapper:width(...)
	return self._gui_obj:width(...)
end

-- Lines: 23 to 24
function GUIObjectWrapper:world_bottom(...)
	return self._gui_obj:world_bottom(...)
end

-- Lines: 24 to 25
function GUIObjectWrapper:world_center(...)
	return self._gui_obj:world_center(...)
end

-- Lines: 25 to 26
function GUIObjectWrapper:world_center_x(...)
	return self._gui_obj:world_center_x(...)
end

-- Lines: 26 to 27
function GUIObjectWrapper:world_center_y(...)
	return self._gui_obj:world_center_y(...)
end

-- Lines: 27 to 28
function GUIObjectWrapper:world_left(...)
	return self._gui_obj:world_left(...)
end

-- Lines: 28 to 29
function GUIObjectWrapper:world_leftbottom(...)
	return self._gui_obj:world_leftbottom(...)
end

-- Lines: 29 to 30
function GUIObjectWrapper:world_lefttop(...)
	return self._gui_obj:world_lefttop(...)
end

-- Lines: 30 to 31
function GUIObjectWrapper:world_position(...)
	return self._gui_obj:world_position(...)
end

-- Lines: 31 to 32
function GUIObjectWrapper:world_right(...)
	return self._gui_obj:world_right(...)
end

-- Lines: 32 to 33
function GUIObjectWrapper:world_rightbottom(...)
	return self._gui_obj:world_rightbottom(...)
end

-- Lines: 33 to 34
function GUIObjectWrapper:world_righttop(...)
	return self._gui_obj:world_righttop(...)
end

-- Lines: 34 to 35
function GUIObjectWrapper:world_top(...)
	return self._gui_obj:world_top(...)
end

-- Lines: 35 to 36
function GUIObjectWrapper:world_x(...)
	return self._gui_obj:world_x(...)
end

-- Lines: 36 to 37
function GUIObjectWrapper:world_y(...)
	return self._gui_obj:world_y(...)
end

-- Lines: 37 to 38
function GUIObjectWrapper:x(...)
	return self._gui_obj:x(...)
end

-- Lines: 38 to 39
function GUIObjectWrapper:y(...)
	return self._gui_obj:y(...)
end

-- Lines: 40 to 41
function GUIObjectWrapper:set_bottom(...)
	self._gui_obj:set_bottom(...)
end

-- Lines: 41 to 42
function GUIObjectWrapper:set_center(...)
	self._gui_obj:set_center(...)
end

-- Lines: 42 to 43
function GUIObjectWrapper:set_center_x(...)
	self._gui_obj:set_center_x(...)
end

-- Lines: 43 to 44
function GUIObjectWrapper:set_center_y(...)
	self._gui_obj:set_center_y(...)
end

-- Lines: 44 to 45
function GUIObjectWrapper:set_debug(...)
	self._gui_obj:set_debug(...)
end

-- Lines: 45 to 46
function GUIObjectWrapper:set_h(...)
	self._gui_obj:set_h(...)
end

-- Lines: 46 to 47
function GUIObjectWrapper:set_height(...)
	self._gui_obj:set_height(...)
end

-- Lines: 47 to 48
function GUIObjectWrapper:set_left(...)
	self._gui_obj:set_left(...)
end

-- Lines: 48 to 49
function GUIObjectWrapper:set_leftbottom(...)
	self._gui_obj:set_leftbottom(...)
end

-- Lines: 49 to 50
function GUIObjectWrapper:set_lefttop(...)
	self._gui_obj:set_lefttop(...)
end

-- Lines: 50 to 51
function GUIObjectWrapper:set_position(...)
	self._gui_obj:set_position(...)
end

-- Lines: 51 to 52
function GUIObjectWrapper:set_right(...)
	self._gui_obj:set_right(...)
end

-- Lines: 52 to 53
function GUIObjectWrapper:set_rightbottom(...)
	self._gui_obj:set_rightbottom(...)
end

-- Lines: 53 to 54
function GUIObjectWrapper:set_righttop(...)
	self._gui_obj:set_righttop(...)
end

-- Lines: 54 to 55
function GUIObjectWrapper:set_size(...)
	self._gui_obj:set_size(...)
end

-- Lines: 55 to 56
function GUIObjectWrapper:set_top(...)
	self._gui_obj:set_top(...)
end

-- Lines: 56 to 57
function GUIObjectWrapper:set_w(...)
	self._gui_obj:set_w(...)
end

-- Lines: 57 to 58
function GUIObjectWrapper:set_width(...)
	self._gui_obj:set_width(...)
end

-- Lines: 58 to 59
function GUIObjectWrapper:set_world_bottom(...)
	self._gui_obj:set_world_bottom(...)
end

-- Lines: 59 to 60
function GUIObjectWrapper:set_world_center(...)
	self._gui_obj:set_world_center(...)
end

-- Lines: 60 to 61
function GUIObjectWrapper:set_world_center_x(...)
	self._gui_obj:set_world_center_x(...)
end

-- Lines: 61 to 62
function GUIObjectWrapper:set_world_center_y(...)
	self._gui_obj:set_world_center_y(...)
end

-- Lines: 62 to 63
function GUIObjectWrapper:set_world_left(...)
	self._gui_obj:set_world_left(...)
end

-- Lines: 63 to 64
function GUIObjectWrapper:set_world_leftbottom(...)
	self._gui_obj:set_world_leftbottom(...)
end

-- Lines: 64 to 65
function GUIObjectWrapper:set_world_lefttop(...)
	self._gui_obj:set_world_lefttop(...)
end

-- Lines: 65 to 66
function GUIObjectWrapper:set_world_position(...)
	self._gui_obj:set_world_position(...)
end

-- Lines: 66 to 67
function GUIObjectWrapper:set_world_right(...)
	self._gui_obj:set_world_right(...)
end

-- Lines: 67 to 68
function GUIObjectWrapper:set_world_rightbottom(...)
	self._gui_obj:set_world_rightbottom(...)
end

-- Lines: 68 to 69
function GUIObjectWrapper:set_world_righttop(...)
	self._gui_obj:set_world_righttop(...)
end

-- Lines: 69 to 70
function GUIObjectWrapper:set_world_top(...)
	self._gui_obj:set_world_top(...)
end

-- Lines: 70 to 71
function GUIObjectWrapper:set_world_x(...)
	self._gui_obj:set_world_x(...)
end

-- Lines: 71 to 72
function GUIObjectWrapper:set_world_y(...)
	self._gui_obj:set_world_y(...)
end

-- Lines: 72 to 73
function GUIObjectWrapper:set_x(...)
	self._gui_obj:set_x(...)
end

-- Lines: 73 to 74
function GUIObjectWrapper:set_y(...)
	self._gui_obj:set_y(...)
end

-- Lines: 75 to 76
function GUIObjectWrapper:layer(...)
	return self._gui_obj:layer(...)
end

-- Lines: 76 to 77
function GUIObjectWrapper:set_layer(...)
	self._gui_obj:set_layer(...)
end

-- Lines: 77 to 78
function GUIObjectWrapper:set_world_layer(...)
	self._gui_obj:set_world_layer(...)
end

-- Lines: 78 to 79
function GUIObjectWrapper:world_layer(...)
	return self._gui_obj:world_layer(...)
end

-- Lines: 80 to 81
function GUIObjectWrapper:inside(...)
	return self._gui_obj:inside(...)
end

-- Lines: 81 to 82
function GUIObjectWrapper:outside(...)
	return self._gui_obj:outside(...)
end

