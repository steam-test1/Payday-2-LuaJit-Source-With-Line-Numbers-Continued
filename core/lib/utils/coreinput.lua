core:module("CoreInput")
core:import("CoreClass")

-- Lines: 18 to 19
function shift()
	return Input:keyboard():down(Idstring("left shift")) or Input:keyboard():down(Idstring("right shift"))
end

-- Lines: 22 to 23
function ctrl()
	return Input:keyboard():down(Idstring("left ctrl")) or Input:keyboard():down(Idstring("right ctrl"))
end

-- Lines: 26 to 27
function alt()
	return Input:keyboard():down(Idstring("left alt"))
end

RepKey = RepKey or CoreClass.class()

-- Lines: 41 to 49
function RepKey:init(keys, pause, rep)
	self._keys = keys or {}
	self._current_time = 0
	self._current_rep_time = 0
	self._pause = pause or 0.5
	self._rep = rep or 0.1
	self._input = Input:keyboard()
end

-- Lines: 51 to 53
function RepKey:set_input(input)
	self._input = input
end

-- Lines: 55 to 90
function RepKey:update(d, dt)
	local anykey = false

	for _, key in ipairs(self._keys) do
		if self._input:down(Idstring(key)) then
			anykey = true

			break
		end
	end

	local down = false

	if anykey then
		if self._current_time == 0 then
			down = true
		end

		if self._pause <= self._current_time then
			down = true

			if self._rep <= self._current_rep_time then
				down = true
				self._current_rep_time = 0
			else
				down = false
				self._current_rep_time = self._current_rep_time + dt
			end
		else
			self._current_time = self._current_time + dt
		end
	else
		self._current_time = 0
		self._current_rep_time = 0
	end

	return down
end

