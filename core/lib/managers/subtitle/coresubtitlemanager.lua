core:module("CoreSubtitleManager")
core:import("CoreClass")
core:import("CoreDebug")
core:import("CoreTable")
core:import("CoreSubtitlePresenter")
core:import("CoreSubtitleSequence")
core:import("CoreSubtitleSequencePlayer")

SubtitleManager = SubtitleManager or CoreClass.class()

-- Lines 11-16
function SubtitleManager:init()
	self.__subtitle_sequences = {}
	self.__loaded_sequence_file_paths = {}
	self.__presenter = CoreSubtitlePresenter.DebugPresenter:new()

	self:_update_presenter_visibility()
end

-- Lines 18-20
function SubtitleManager:destroy()
	self:set_presenter(nil)
end

-- Lines 22-24
function SubtitleManager:presenter()
	return assert(self.__presenter, "Invalid presenter. SubtitleManager might have been destroyed.")
end

-- Lines 26-41
function SubtitleManager:set_presenter(presenter)
	assert(presenter == nil or type(presenter.preprocess_sequence) == "function", "Invalid presenter.")

	if self.__player then
		self.__player = nil
	end

	if self.__presenter then
		self.__presenter:destroy()
	end

	self.__presenter = presenter

	if self.__presenter then
		self:_update_presenter_visibility()
	end
end

-- Lines 43-54
function SubtitleManager:load_sequences(sequence_file_path)
	local root_node = DB:load_node("subtitle_sequence", sequence_file_path)

	assert(root_node:name() == "subtitle_sequence", "File is not a subtitle sequence file.")

	self.__loaded_sequence_file_paths[sequence_file_path] = true

	for sequence_node in root_node:children() do
		if sequence_node:name() == "sequence" then
			local sequence = CoreSubtitleSequence.SubtitleSequence:new(sequence_node)
			self.__subtitle_sequences[sequence:name()] = sequence
		end
	end
end

-- Lines 56-61
function SubtitleManager:reload_sequences()
	self.__subtitle_sequences = {}

	for sequence_file_path, _ in pairs(self.__loaded_sequence_file_paths) do
		self:load_sequences(sequence_file_path)
	end
end

-- Lines 63-72
function SubtitleManager:update(time, delta_time)
	if self.__player then
		self.__player:update(time, delta_time)

		if self.__player:is_done() then
			self.__player = nil
		end
	end

	self:presenter():update(time, delta_time)
end

-- Lines 74-76
function SubtitleManager:enabled()
	return Global.__SubtitleManager__enabled or false
end

-- Lines 78-81
function SubtitleManager:set_enabled(enabled)
	Global.__SubtitleManager__enabled = not not enabled

	self:_update_presenter_visibility()
end

-- Lines 83-85
function SubtitleManager:visible()
	return not self.__hidden
end

-- Lines 87-90
function SubtitleManager:set_visible(visible)
	self.__hidden = not visible or nil

	self:_update_presenter_visibility()
end

-- Lines 92-94
function SubtitleManager:clear_subtitle()
	self:show_subtitle_localized("")
end

-- Lines 96-98
function SubtitleManager:is_showing_subtitles()
	return self:enabled() and self:visible() and self.__player ~= nil
end

-- Lines 100-102
function SubtitleManager:show_subtitle(string_id, duration, macros)
	self:show_subtitle_localized(managers.localization:text(string_id, macros), duration)
end

-- Lines 104-108
function SubtitleManager:show_subtitle_localized(localized_string, duration)
	local sequence = CoreSubtitleSequence.SubtitleSequence:new()

	sequence:add_subtitle(CoreSubtitleSequence.Subtitle:new(localized_string, 0, duration or 3))

	self.__player = CoreSubtitleSequencePlayer.SubtitleSequencePlayer:new(sequence, self:presenter())
end

-- Lines 110-113
function SubtitleManager:run_subtitle_sequence(sequence_id)
	local sequence = sequence_id and assert(self.__subtitle_sequences[sequence_id], string.format("Sequence \"%s\" not found.", sequence_id))
	self.__player = sequence and CoreSubtitleSequencePlayer.SubtitleSequencePlayer:new(sequence, self:presenter())
end

-- Lines 115-117
function SubtitleManager:subtitle_sequence_ids()
	return CoreTable.table.map_keys(self.__subtitle_sequences or {})
end

-- Lines 119-121
function SubtitleManager:has_subtitle_sequence(sequence_id)
	return (self.__subtitle_sequences and self.__subtitle_sequences[sequence_id]) ~= nil
end

-- Lines 123-127
function SubtitleManager:_update_presenter_visibility()
	local presenter = self:presenter()
	local show_presenter = self:enabled() and self:visible() and (not managers.user or managers.user:get_setting("subtitle"))

	presenter[show_presenter and "show" or "hide"](presenter)
end
