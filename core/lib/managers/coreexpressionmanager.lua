core:module("CoreExpressionManager")

ExpressionManager = ExpressionManager or class()

-- Lines 5-8
function ExpressionManager:init()
	self._units = {}
	self._preloads = {}
end

-- Lines 10-16
function ExpressionManager:update(t, dt)
	for i, exp in pairs(self._units) do
		if not exp:update(t, dt) then
			self._units[i] = nil
		end
	end
end

-- Lines 18-20
function ExpressionManager:preload(movie_name)
	self._preloads[movie_name] = Database:load_node(Database:lookup("expression", movie_name))
end

-- Lines 22-24
function ExpressionManager:play(unit, target, movie_name, loop)
	self._units[unit:key()] = CoreExpressionMovie:new(unit, target, movie_name, self._preloads[movie_name], loop)
end

-- Lines 26-28
function ExpressionManager:stop(unit)
	self._units[unit:key()] = nil
end
