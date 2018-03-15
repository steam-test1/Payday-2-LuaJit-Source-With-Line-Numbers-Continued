HandExt = HandExt or class()

-- Lines: 4 to 6
function HandExt:init(hand_unit)
	self._unit = hand_unit
end

-- Lines: 8 to 11
function HandExt:set_other_hand_unit(other_unit)
	self._other_hand_unit = other_unit
	self._other_hand_base = other_unit:base()
end

-- Lines: 13 to 15
function HandExt:set_hand_data(hand_data)
	self._hand_data = hand_data
end

-- Lines: 17 to 18
function HandExt:other_hand_unit()
	return self._other_hand_unit
end

-- Lines: 21 to 22
function HandExt:other_hand_base()
	return self._other_hand_base
end

-- Lines: 25 to 26
function HandExt:position()
	return self._hand_data.position
end

-- Lines: 29 to 30
function HandExt:finger_position()
	return self._hand_data.finger_position
end

-- Lines: 33 to 34
function HandExt:rotation()
	return self._hand_data.rotation
end

-- Lines: 37 to 38
function HandExt:raw_rotation()
	return self._hand_data.raw_rotation
end

-- Lines: 41 to 42
function HandExt:name()
	return self._hand_data.hand
end

-- Lines: 45 to 46
function HandExt:unit()
	return self._unit
end

-- Lines: 49 to 51
function HandExt:post_event(event, sound_source)
	self._unit:sound_source(sound_source):post_event(event)
end

-- Lines: 54 to 55
function HandExt:update_variables()
end

