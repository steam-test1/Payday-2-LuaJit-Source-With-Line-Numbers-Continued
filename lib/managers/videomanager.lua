VideoManager = VideoManager or class()

-- Lines: 3 to 5
function VideoManager:init()
	self._videos = {}
end

-- Lines: 7 to 12
function VideoManager:add_video(video)
	local volume = managers.user:get_setting("sfx_volume")
	local percentage = (volume - tweak_data.menu.MIN_SFX_VOLUME) / (tweak_data.menu.MAX_SFX_VOLUME - tweak_data.menu.MIN_SFX_VOLUME)

	video:set_volume_gain(percentage)
	table.insert(self._videos, video)
end

-- Lines: 14 to 16
function VideoManager:remove_video(video)
	table.delete(self._videos, video)
end

-- Lines: 18 to 22
function VideoManager:volume_changed(volume)
	for _, video in ipairs(self._videos) do
		video:set_volume_gain(volume)
	end
end

