TeamAISound = TeamAISound or class(PlayerSound)

-- Lines: 3 to 10
function TeamAISound:init(unit)
	self._unit = unit

	unit:base():post_init()

	local ss = unit:sound_source()

	ss:set_switch("robber", tweak_data.character[unit:base()._tweak_table].speech_prefix)
	ss:set_switch("int_ext", "third")
end

-- Lines: 14 to 18
function TeamAISound:set_voice(voice)
	local ss = self._unit:sound_source()

	ss:set_switch("robber", voice)
	ss:set_switch("int_ext", "third")
end

