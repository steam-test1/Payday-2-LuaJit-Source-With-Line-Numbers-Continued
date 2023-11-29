DummyCorpseBase = DummyCorpseBase or class(UnitBase)
DummyCorpseBase._material_translation_map = CopBase._material_translation_map
DummyCorpseBase.swap_material_config = CopBase.swap_material_config
DummyCorpseBase.is_in_original_material = CopBase.is_in_original_material
DummyCorpseBase.set_material_state = CopBase.set_material_state
DummyCorpseBase.on_material_applied = CopBase.on_material_applied

-- Lines 10-14
function DummyCorpseBase:init(unit)
	UnitBase.init(self, unit, false)

	self._is_in_original_material = true
end
