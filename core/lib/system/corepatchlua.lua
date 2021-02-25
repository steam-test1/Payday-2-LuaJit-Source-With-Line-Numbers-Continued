local mt = getmetatable(_G)

if mt == nil then
	mt = {}

	setmetatable(_G, mt)
end

mt.__declared = {}

-- Lines 21-30
function mt.__newindex(t, n, v)
	if not mt.__declared[n] then
		local info = debug.getinfo(2, "S")

		if info and info.what ~= "main" and info.what ~= "C" then
			error("cannot assign undeclared global '" .. tostring(n) .. "'", 2)
		end

		mt.__declared[n] = true
	end

	rawset(t, n, v)
end

-- Lines 32-39
function mt.__index(t, n)
	if not mt.__declared[n] then
		local info = debug.getinfo(2, "S")

		if info and info.what ~= "main" and info.what ~= "C" then
			error("cannot use undeclared global '" .. tostring(n) .. "'", 2)
		end
	end
end
