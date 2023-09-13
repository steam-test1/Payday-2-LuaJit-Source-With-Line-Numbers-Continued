DateTime = DateTime or class()
DateTime.days_per_week = 7
DateTime.days_per_month = 31
DateTime.months_per_year = 12

-- Lines 14-65
function DateTime:init(date)
	if type(date) == "string" and (date == "now" or date == "today") then
		date = {
			tonumber(os.date("%Y")),
			tonumber(os.date("%m")),
			tonumber(os.date("%d"))
		}
	end

	self._date_table = {
		year = date[1] or date.year or date._date_table and date._date_table.year or 0,
		month = date[2] or date.month or date._date_table and date._date_table.month or 0,
		day = date[3] or date.day or date._date_table and date._date_table.day or 0
	}
	self._value = 0
	self._value = self._value + self._date_table.year * DateTime.days_per_month * DateTime.months_per_year
	self._value = self._value + self._date_table.month * DateTime.days_per_month
	self._value = self._value + self._date_table.day
	local mt = getmetatable(self)

	-- Lines 37-39
	function mt.__eq(a, b)
		return a:value() == b:value()
	end

	-- Lines 40-42
	function mt.__lt(a, b)
		return a:value() < b:value()
	end

	-- Lines 43-45
	function mt.__le(a, b)
		return a:value() <= b:value()
	end

	-- Lines 46-52
	function mt.__add(a, b)
		local f = {
			year = (a._date_table.year or 0) + (b._date_table.year or 0),
			month = (a._date_table.month or 0) + (b._date_table.month or 0),
			day = (a._date_table.day or 0) + (b._date_table.day or 0)
		}

		return DateTime:new(f)
	end

	-- Lines 53-59
	function mt.__sub(a, b)
		local f = {
			year = (a._date_table.year or 0) - (b._date_table.year or 0),
			month = (a._date_table.month or 0) - (b._date_table.month or 0),
			day = (a._date_table.day or 0) - (b._date_table.day or 0)
		}

		return DateTime:new(f)
	end

	-- Lines 60-62
	function mt.__tostring(t)
		return string.format("%i/%i/%i [%i]", t._date_table.year or -1, t._date_table.month or -1, t._date_table.day or -1, t:value())
	end

	setmetatable(self, mt)
end

-- Lines 67-69
function DateTime:value()
	return self._value
end

-- Lines 71-73
function DateTime:date()
	return self._date_table
end
