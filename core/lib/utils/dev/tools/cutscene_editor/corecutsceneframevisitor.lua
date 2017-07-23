CoreCutsceneFrameVisitor = CoreCutsceneFrameVisitor or class()

-- Lines: 3 to 10
function CoreCutsceneFrameVisitor:init(parent_window, cutscene_editor, start_frame, end_frame)
	self.__parent_window = assert(parent_window)
	self.__cutscene_editor = assert(cutscene_editor)
	self.__start_frame = assert(tonumber(start_frame))
	self.__end_frame = assert(tonumber(end_frame))
	self.__frame = self.__start_frame

	assert(type(self._visit_frame) == "function", "Subclasses of CoreCutsceneFrameVisitor must define _visit_frame(frame).")
end

-- Lines: 12 to 23
function CoreCutsceneFrameVisitor:begin()
	assert(alive(self.__parent_window), "Parent window has been destroyed.")

	if not alive(self.__progress_dialog) then
		self.__progress_dialog = EWS:ProgressDialog(self.__parent_window, "Exporting Frames...", "Preparing for export", self.__end_frame - self.__start_frame, "PD_AUTO_HIDE,PD_APP_MODAL,PD_CAN_ABORT,PD_REMAINING_TIME")
	end

	self.__progress_dialog:set_visible(true)

	self.__frame = self.__start_frame

	self.__cutscene_editor:set_playhead_position(self.__frame)
	self.__cutscene_editor:refresh_player()
end

-- Lines: 26 to 49
function CoreCutsceneFrameVisitor:update(time, delta_time)
	Application:set_forced_timestep(0.03333333333333333)

	if not self:_is_ready_to_go() then
		return false
	end

	local was_aborted = not self.__progress_dialog:update_bar(self.__frame - self.__start_frame, self:_progress_message(self.__frame))
	local is_done = was_aborted or self.__end_frame <= self.__frame

	if is_done then
		self:_done(was_aborted)

		if alive(self.__progress_dialog) then
			self.__progress_dialog:destroy()
		end

		self.__progress_dialog = nil

		self.__cutscene_editor:enqueue_update_action(callback(self, self, "_cleanup"))
	else
		self.__cutscene_editor:set_playhead_position(self.__frame)
		self.__cutscene_editor:refresh_player()

		self.__should_visit_frame_at_end_update = true
	end

	return is_done
end

-- Lines: 52 to 58
function CoreCutsceneFrameVisitor:end_update(time, delta_time)
	if self.__should_visit_frame_at_end_update then
		self:_visit_frame(self.__frame)

		self.__frame = self.__frame + 1
		self.__should_visit_frame_at_end_update = nil
	end
end

-- Lines: 63 to 64
function CoreCutsceneFrameVisitor:_done(aborted)
end

-- Lines: 72 to 74
function CoreCutsceneFrameVisitor:_is_ready_to_go()
	self.__sync_frames = (self.__sync_frames or 30) - 1

	return self.__sync_frames <= 0
end

-- Lines: 77 to 78
function CoreCutsceneFrameVisitor:_progress_message(frame)
	return "Processing frame " .. frame
end

-- Lines: 84 to 87
function CoreCutsceneFrameVisitor:_cleanup()
	Application:set_forced_timestep(0)

	self.__sync_frames = nil
end

