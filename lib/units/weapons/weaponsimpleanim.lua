WeaponSimpleAnim = WeaponSimpleAnim or class(WeaponSecondSight)
WeaponSimpleAnim.GADGET_TYPE = "simple_anim"

-- Lines: 4 to 14
function WeaponSimpleAnim:init(unit)
	WeaponSimpleAnim.super.init(self, unit)

	self._on_event = "wp_gl40_sight_on"
	self._off_event = "wp_gl40_sight_off"
	self._anim_state = self._on

	if self.anim then
		self._anim = Idstring(self.anim)
	end
end

-- Lines: 18 to 25
function WeaponSimpleAnim:_check_state(current_state)
	if self._anim_state ~= self._on then
		self._anim_state = self._on

		self:play_anim()
	end

	WeaponSimpleAnim.super._check_state(self, current_state)
end

-- Lines: 27 to 35
function WeaponSimpleAnim:play_anim()
	if not self._anim then
		return
	end

	local length = self._unit:anim_length(self._anim)
	local speed = self._anim_state and 1 or -1

	self._unit:anim_play_to(self._anim, self._anim_state and length or 0, speed)
end

-- Lines: 37 to 38
function WeaponSimpleAnim:toggle_requires_stance_update()
	return true
end

-- Lines: 43 to 45
function WeaponSimpleAnim:destroy(unit)
	WeaponSimpleAnim.super.destroy(self, unit)
end

