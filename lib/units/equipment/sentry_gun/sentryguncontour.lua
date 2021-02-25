SentryGunContour = SentryGunContour or class()

-- Lines 6-9
function SentryGunContour:init(unit)
	self._unit = unit

	unit:event_listener():add("SentryGunContour_on_setup_event", {
		"on_setup"
	}, callback(self, self, "_on_setup_event"))
end

-- Lines 11-21
function SentryGunContour:_on_setup_event(is_owner)
	local event_listener = self._unit:event_listener()

	if self._owner_only and is_owner or not self._owner_only then
		self._current_contour_id = self:standard_contour_id()

		self:_set_contour(self._current_contour_id)
		event_listener:add("SentryGunContour_on_switch_fire_mode_event", {
			"on_switch_fire_mode"
		}, callback(self, self, "_on_switch_fire_mode_event"))
		event_listener:add("SentryGunContour_on_out_of_ammo_event", {
			"on_out_of_ammo"
		}, callback(self, self, "_on_out_of_ammo_event"))
		event_listener:add("SentryGunContour_on_death_event", {
			"on_death"
		}, callback(self, self, "_on_death_event"))
	end

	event_listener:remove("SentryGunContour_on_setup_event")
end

-- Lines 23-29
function SentryGunContour:_on_switch_fire_mode_event(ap_bullets)
	if ap_bullets then
		self:_set_contour(self:ap_contour_id())
	else
		self:_set_contour(self:standard_contour_id())
	end
end

-- Lines 31-33
function SentryGunContour:_on_out_of_ammo_event()
	self:_set_contour(self:out_of_ammo_contour_id())
end

-- Lines 35-37
function SentryGunContour:_on_death_event()
	self:_remove_contour()
end

-- Lines 39-41
function SentryGunContour:standard_contour_id()
	return self._standard_contour_id or "deployable_active"
end

-- Lines 43-45
function SentryGunContour:ap_contour_id()
	return self._ap_contour_id or "deployable_interactable"
end

-- Lines 47-49
function SentryGunContour:out_of_ammo_contour_id()
	return self._no_ammo_contour_id or "deployable_disabled"
end

-- Lines 51-61
function SentryGunContour:_set_contour(contour_id)
	local contour = self._unit:contour()

	if contour then
		if self._current_contour_id then
			contour:remove(self._current_contour_id)
		end

		contour:add(contour_id)

		self._current_contour_id = contour_id
	end
end

-- Lines 63-69
function SentryGunContour:_remove_contour()
	local contour = self._unit:contour()

	if contour then
		contour:remove(self._current_contour_id)

		self._current_contour_id = nil
	end
end
