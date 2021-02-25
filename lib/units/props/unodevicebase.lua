UnoDeviceBase = UnoDeviceBase or class(UnitBase)
UnoDeviceBase.TEXT_HEIGHT = 200

-- Lines 5-25
function UnoDeviceBase:init(unit)
	UnoDeviceBase.super.init(self, unit, false)

	local text_object = unit:get_object(Idstring("gui_object"))
	local gui = World:gui()
	local ws = gui:create_object_workspace(0, UnoDeviceBase.TEXT_HEIGHT, text_object)
	local panel = ws:panel()
	self._gui = gui
	self._ws = ws
	self._panel = panel

	self:build_hint_text()

	self._next_hint = 1
end

-- Lines 27-45
function UnoDeviceBase:build_hint_text()
	if self._hint_text then
		self._panel:remove(self._hint_text)
	end

	local font = tweak_data.menu.uno_vessel_font
	local font_size = tweak_data.menu.uno_vessel_font_size
	self._hint_text = self._panel:text({
		text = "",
		direction = "right_left",
		wrap = true,
		align = "center",
		vertical = "center",
		font = font,
		font_size = font_size,
		color = Color(0, 1, 1, 1)
	})
end

-- Lines 47-51
local function text_fade(o, start_color, end_color, duration)
	for t, p, dt in seconds(duration) do
		o:set_color(start_color * (1 - p) + end_color * p)
	end
end

-- Lines 53-61
function UnoDeviceBase:show_text(text)
	self._hint_text:set_text(text)
	self._hint_text:stop()
	self._hint_text:animate(function (o)
		text_fade(o, Color(0, 1, 1, 1), Color(1, 1, 1, 1), 0.3)
		wait(10)
		text_fade(o, Color(1, 1, 1, 1), Color(0, 1, 1, 1), 0.3)
	end)
end

-- Lines 63-73
function UnoDeviceBase:cycle_hints()
	local uno_challenge = managers.custom_safehouse:uno_achievement_challenge()
	local achievement_id = uno_challenge:challenge()[self._next_hint]

	self:show_hint(achievement_id)

	self._next_hint = self._next_hint + 1

	if UnoAchievementChallenge.CHALLENGE_COUNT < self._next_hint then
		self._next_hint = 1
	end
end

-- Lines 75-85
function UnoDeviceBase:show_hint(achievement_id)
	local hint_text = managers.localization:text("uno_device_hint_" .. Idstring(achievement_id):key())

	self:show_text(hint_text)
end

-- Lines 87-91
function UnoDeviceBase:generate_challenge()
	local uno_challenge = managers.custom_safehouse:uno_achievement_challenge()

	uno_challenge:generate_challenge()

	self._next_hint = 1
end

-- Lines 93-100
function UnoDeviceBase:destroy()
	if alive(self._ws) then
		self._gui:destroy_workspace(self._ws)
	end

	self._gui = nil
	self._ws = nil
end
