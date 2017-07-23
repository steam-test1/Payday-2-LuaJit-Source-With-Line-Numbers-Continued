ServerSyncedCivilianDamage = ServerSyncedCivilianDamage or class(CivilianDamage)
ServerSyncedCivilianDamage._RESULT_INDEX_TABLE = {
	light_hurt = 2,
	hurt = 1,
	heavy_hurt = 3,
	death = 4
}

-- Lines: 8 to 10
function ServerSyncedCivilianDamage:_send_bullet_attack_result(attack_data, attacker, damage_percent, body_index, hit_offset_height)
	self:_send_sync_bullet_attack_result(attack_data, hit_offset_height)
end

-- Lines: 12 to 14
function ServerSyncedCivilianDamage:_send_explosion_attack_result(attack_data, attacker, damage_percent)
	self:_send_sync_explosion_attack_result(attack_data)
end

-- Lines: 16 to 18
function ServerSyncedCivilianDamage:_send_fire_attack_result(attack_data, attacker, damage_percent)
	self:_send_sync_fire_attack_result(attack_data)
end

-- Lines: 20 to 22
function ServerSyncedCivilianDamage:_send_melee_attack_result(attack_data, damage_percent, hit_offset_height)
	self:_send_sync_melee_attack_result(attack_data, hit_offset_height, 0)
end

-- Lines: 26 to 28
function ServerSyncedCivilianDamage:_send_sync_bullet_attack_result(attack_data, hit_offset_height)
	TeamAIDamage._send_bullet_attack_result(self, attack_data, hit_offset_height)
end

-- Lines: 30 to 32
function ServerSyncedCivilianDamage:_send_sync_explosion_attack_result(attack_data)
	TeamAIDamage._send_explosion_attack_result(self, attack_data)
end

-- Lines: 34 to 36
function ServerSyncedCivilianDamage:_send_sync_fire_attack_result(attack_data)
	TeamAIDamage._send_fire_attack_result(self, attack_data)
end

-- Lines: 38 to 40
function ServerSyncedCivilianDamage:_send_sync_melee_attack_result(attack_data, hit_offset_height, variant)
	TeamAIDamage._send_melee_attack_result(self, attack_data, hit_offset_height, variant)
end

