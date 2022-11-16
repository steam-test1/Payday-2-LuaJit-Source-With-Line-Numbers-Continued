AnniversaryPiggyBank = AnniversaryPiggyBank or class(UnitBase)

-- Lines 4-10
function AnniversaryPiggyBank:init(unit)
	AnniversaryPiggyBank.super.init(self, unit, false)

	if managers.mutators:is_mutator_active(MutatorPiggyBank) then
		self._piggybank_mutator = managers.mutators:get_mutator(MutatorPiggyBank)
	end
end

-- Lines 12-14
function AnniversaryPiggyBank:sync_feed_pig()
	managers.menu:post_event("bar_armor_finished")
end

-- Lines 16-19
function AnniversaryPiggyBank:explode_pig(unit)
	self._piggybank_mutator:on_pig_exploded(unit)
end

-- Lines 21-22
function AnniversaryPiggyBank:sync_explode_pig(pig_level)
end

-- Lines 24-31
function AnniversaryPiggyBank:on_interacted()
	if not Network:is_server() then
		return
	end

	self:explode_pig()
end

-- Lines 35-40
function AnniversaryPiggyBank:run_sequence(sequence)
	print("AnniversaryPiggyBank:run_sequence", sequence, self._unit)

	if sequence and self._unit:damage():has_sequence(sequence) then
		self._unit:damage():run_sequence_simple(sequence)
	end
end
