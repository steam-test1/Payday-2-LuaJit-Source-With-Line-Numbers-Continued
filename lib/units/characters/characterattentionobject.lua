require("lib/units/props/AIAttentionObject")

CharacterAttentionObject = CharacterAttentionObject or class(AIAttentionObject)

-- Lines 5-7
function CharacterAttentionObject:init(unit)
	CharacterAttentionObject.super.init(self, unit, true)
end

-- Lines 11-16
function CharacterAttentionObject:setup_attention_positions(m_att_pos, m_pos, m_detect_pos)
	local mov_ext = self._unit:movement()
	self._m_att_pos = m_att_pos or mov_ext:m_head_pos()
	self._m_pos = m_pos or mov_ext:m_pos()
	self._m_detect_pos = m_detect_pos or mov_ext.m_detect_pos and mov_ext:m_detect_pos() or self._m_att_pos
end

-- Lines 20-58
function CharacterAttentionObject:chk_settings_diff(settings_set)
	local attention_data = self._attention_data
	local changes = nil

	if settings_set then
		for _, id in ipairs(settings_set) do
			if not attention_data or not attention_data[id] then
				changes = changes or {}
				changes.added = changes.added or {}

				table.insert(changes.added, id)
			elseif attention_data then
				changes = changes or {}
				changes.maintained = changes.maintained or {}

				table.insert(changes.maintained, id)
			end
		end
	end

	if attention_data then
		for old_id, setting in pairs(attention_data) do
			local found = nil

			if settings_set then
				for _, new_id in ipairs(settings_set) do
					if old_id == new_id then
						found = true

						break
					end
				end
			end

			if not found then
				changes = changes or {}
				changes.removed = changes.removed or {}

				table.insert(changes.removed, old_id)
			end
		end
	end

	return changes
end

-- Lines 62-133
function CharacterAttentionObject:set_settings_set(settings_set)
	local attention_data = self._attention_data
	local changed, register, unregister = nil

	if attention_data then
		if not settings_set or not next(settings_set) then
			settings_set = nil
			unregister = true
		else
			for id, settings in pairs(attention_data) do
				if not settings_set[id] then
					changed = true

					break
				end
			end

			if not changed then
				for id, settings in pairs(settings_set) do
					if not attention_data[id] then
						changed = true

						break
					end
				end
			end
		end
	elseif settings_set and next(settings_set) then
		register = true
	end

	if self._overrides then
		if settings_set then
			for id, overrride_setting in pairs(self._overrides) do
				if settings_set[id] then
					self._override_restore = self._override_restore or {}
					self._override_restore[id] = settings_set[id]
					settings_set[id] = overrride_setting
				end
			end

			if attention_data and self._override_restore then
				for id, setting in pairs(attention_data) do
					if not settings_set[id] then
						self._override_restore[id] = nil
					end
				end

				if not next(self._override_restore) then
					self._override_restore = nil
				end
			end
		else
			self._override_restore = nil
		end
	end

	self._attention_data = settings_set

	if register then
		if not self._registered then
			self:_register()
		end
	elseif unregister and self._registered then
		self:_unregister()
	end

	if changed then
		self:_call_listeners()
		self:_chk_update_registered_state()
	end
end

-- Lines 137-139
function CharacterAttentionObject:get_attention_m_pos(settings)
	return self._m_att_pos
end

-- Lines 143-145
function CharacterAttentionObject:get_detection_m_pos()
	return self._m_detect_pos
end

-- Lines 149-151
function CharacterAttentionObject:get_ground_m_pos()
	return self._m_pos
end

-- Lines 155-164
function CharacterAttentionObject:is_attention_irrelevant_for_weapons_hot(...)
	return false
end
