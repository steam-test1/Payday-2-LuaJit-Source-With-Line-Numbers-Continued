HuskTeamAIMovement = HuskTeamAIMovement or class(TeamAIMovement)

-- Lines: 3 to 8
function HuskTeamAIMovement:init(unit)
	HuskTeamAIMovement.super.init(self, unit)

	self._queued_actions = {}
	self._m_host_stop_pos = mvector3.copy(self._m_pos)
end

-- Lines: 12 to 14
function HuskTeamAIMovement:_post_init()
	self:play_redirect("idle")
end

-- Lines: 18 to 25
function HuskTeamAIMovement:sync_arrested()
	self._unit:interaction():set_tweak_data("free")
	self._unit:interaction():set_active(true, false)
	managers.hud:set_mugshot_cuffed(self._unit:unit_data().mugshot_id)
	self._unit:base():set_slot(self._unit, 24)
end

-- Lines: 29 to 35
function HuskTeamAIMovement:add_weapons()
	local weapon = self._ext_base:default_weapon_name("primary")
	local _ = weapon and self._unit:inventory():add_unit_by_factory_name(weapon, false, false, nil, "")
	local sec_weap_name = self._ext_base:default_weapon_name("secondary")
	local _ = sec_weap_name and sec_weap_name ~= weapon and self._unit:inventory():add_unit_by_name(sec_weap_name)
end

-- Lines: 39 to 42
function HuskTeamAIMovement:_upd_actions(t)
	TeamAIMovement._upd_actions(self, t)
	HuskCopMovement._chk_start_queued_action(self)
end

-- Lines: 46 to 47
function HuskTeamAIMovement:action_request(action_desc)
	return HuskCopMovement.action_request(self, action_desc)
end

-- Lines: 52 to 53
function HuskTeamAIMovement:chk_action_forbidden(action_desc)
	return HuskCopMovement.chk_action_forbidden(self, action_desc)
end

return
