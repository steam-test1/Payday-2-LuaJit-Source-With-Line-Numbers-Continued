TankMedicCopDamage = TankMedicCopDamage or class(MedicDamage)
TankMedicCopDamage._priority_bodies_ids = TankCopDamage._priority_bodies_ids
TankMedicCopDamage.seq_clbk_vizor_shatter = TankCopDamage.seq_clbk_vizor_shatter
