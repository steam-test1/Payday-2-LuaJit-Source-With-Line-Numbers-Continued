TeamAIBase = TeamAIBase or class(CopBase)

-- Lines 3-18
function TeamAIBase:post_init()
	self._ext_movement = self._unit:movement()
	self._ext_anim = self._unit:anim_data()

	self._ext_movement:post_init(true)
	self._unit:brain():post_init()
	self:set_anim_lod(1)

	self._lod_stage = 1
	self._allow_invisible = true

	self:_register()
	managers.occlusion:remove_occlusion(self._unit)
end

-- Lines 22-25
function TeamAIBase:nick_name()
	local name = self._tweak_table

	return managers.localization:text("menu_" .. name)
end

-- Lines 29-31
function TeamAIBase:default_weapon_name(slot)
	return tweak_data.character[self._tweak_table].weapon.weapons_of_choice[slot or "primary"]
end

-- Lines 35-37
function TeamAIBase:arrest_settings()
	return tweak_data.character[self._tweak_table].arrest
end

-- Lines 41-51
function TeamAIBase:pre_destroy(unit)
	self:remove_upgrades()
	self:unregister()
	UnitBase.pre_destroy(self, unit)
	unit:brain():pre_destroy(unit)
	unit:movement():pre_destroy()
	unit:inventory():pre_destroy(unit)
	unit:character_damage():pre_destroy()
end

-- Lines 56-74
function TeamAIBase:set_loadout(loadout)
	if self._loadout then
		self:remove_upgrades()
	end

	-- Lines 61-67
	local function aquire(item)
		local definition = tweak_data.upgrades.crew_skill_definitions[item] or {
			upgrades = item and {
				{
					category = "team",
					upgrade = item
				}
			} or {}
		}

		for _, v in pairs(definition.upgrades) do
			managers.player:aquire_incremental_upgrade({
				category = v.category,
				upgrade = v.upgrade
			})
		end
	end

	aquire("crew_active")
	aquire(loadout.ability)
	aquire(loadout.skill)

	self._loadout = loadout
end

-- Lines 79-94
function TeamAIBase:remove_upgrades()
	if self._loadout then
		-- Lines 81-87
		local function unaquire(item)
			local definition = tweak_data.upgrades.crew_skill_definitions[item] or {
				upgrades = item and {
					{
						category = "team",
						upgrade = item
					}
				} or {}
			}

			for _, v in pairs(definition.upgrades) do
				managers.player:unaquire_incremental_upgrade({
					category = v.category,
					upgrade = v.upgrade
				})
			end
		end

		unaquire("crew_active")
		unaquire(self._loadout.ability)
		unaquire(self._loadout.skill)

		self._loadout = nil
	end
end

-- Lines 98-109
function TeamAIBase:save(data)
	local character = managers.criminals:character_by_unit(self._unit)
	local visual_seed = character and character.visual_state and character.visual_state.visual_seed
	data.base = {
		tweak_table = self._tweak_table,
		loadout = managers.blackmarket:henchman_loadout_string_from_loadout(self._loadout),
		visual_seed = visual_seed
	}
end

-- Lines 113-117
function TeamAIBase:on_death_exit()
	TeamAIBase.super.on_death_exit(self)
	self:unregister()
	self:set_slot(self._unit, 0)
end

-- Lines 121-126
function TeamAIBase:_register()
	if not self._registered then
		managers.groupai:state():register_criminal(self._unit)

		self._registered = true
	end
end

-- Lines 130-141
function TeamAIBase:unregister()
	if self._registered then
		if Network:is_server() then
			self._unit:brain():attention_handler():set_attention(nil)
		end

		if managers.groupai:state():all_AI_criminals()[self._unit:key()] then
			managers.groupai:state():unregister_criminal(self._unit)
		end

		self._char_name = managers.criminals:character_name_by_unit(self._unit)
		self._registered = nil
	end
end

-- Lines 145-146
function TeamAIBase:chk_freeze_anims()
end

-- Lines 150-152
function TeamAIBase:character_name()
	return managers.criminals:character_name_by_unit(self._unit)
end
