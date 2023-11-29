CopActionHealed = CopActionHealed or class()

-- Lines 5-31
function CopActionHealed:init(action_desc, common_data)
	self._common_data = common_data
	self._ext_movement = common_data.ext_movement
	self._ext_inventory = common_data.ext_inventory
	self._ext_anim = common_data.ext_anim
	self._body_part = action_desc.body_part
	self._unit = common_data.unit
	self._machine = common_data.machine
	self._action_desc = action_desc

	if self._ext_anim.upper_body_active and not self._ext_anim.upper_body_empty then
		self._ext_movement:play_redirect("up_idle")
	end

	if not self._ext_movement:play_redirect("use_syringe", action_desc.start_anim_time) then
		return
	end

	self._unit:sound():say("hr01")
	CopActionAct._create_blocks_table(self, action_desc.blocks)
	self._ext_movement:enable_update()

	return true
end

-- Lines 33-37
function CopActionHealed:on_exit()
	if self._expired then
		CopActionWalk._chk_correct_pose(self)
	end
end

-- Lines 39-43
function CopActionHealed:update(t)
	if not self._ext_anim.heal then
		self._expired = true
	end
end

-- Lines 45-47
function CopActionHealed:type()
	return "healed"
end

-- Lines 49-51
function CopActionHealed:expired()
	return self._expired
end

-- Lines 53-59
function CopActionHealed:chk_block(action_type, t)
	if action_type == "death" then
		return false
	end

	return CopActionAct.chk_block(self, action_type, t)
end

-- Lines 61-63
function CopActionHealed:body_part()
	return self._body_part
end

-- Lines 65-67
function CopActionHealed:need_upd()
	return true
end

-- Lines 69-77
function CopActionHealed:save(save_data)
	if self._ext_anim.heal then
		for k, v in pairs(self._action_desc) do
			save_data[k] = v
		end

		save_data.start_anim_time = self._machine:segment_real_time(Idstring("base"))
	end
end
