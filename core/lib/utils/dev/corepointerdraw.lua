core:module("CorePointerDraw")
core:import("CoreClass")
core:import("CoreEvent")
core:import("CoreDebug")

PointerDraw = PointerDraw or CoreClass.class()

-- Lines 8-13
function PointerDraw:init(color, size, position)
	self.__shape = shape or "sphere"
	self.__color = color or Color("ff0000")
	self.__position = position
	self.__size = size or 30
end

-- Lines 15-22
function PointerDraw:update(time, delta_time)
	if self.__position then
		local pen = Draw:pen()

		pen:set("no_z")
		pen:set(self.__color)
		pen:sphere(self.__position, self.__size)
	end
end

-- Lines 24-26
function PointerDraw:set_position(position)
	self.__position = position
end
