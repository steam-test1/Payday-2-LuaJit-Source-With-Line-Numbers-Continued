core:module("CoreString")

-- Lines 15-21
function utf8.find_char(text, char)
	for i, c in ipairs(utf8.characters(text)) do
		if c == char then
			return i
		end
	end
end

-- Lines 27-33
function string.begins(s, beginning)
	if s and beginning then
		return s:sub(1, #beginning) == beginning
	end

	return false
end

-- Lines 35-41
function string.ends(s, ending)
	if s and ending then
		return #ending == 0 or s:sub(-(#ending)) == ending
	end

	return false
end

-- Lines 46-48
function string.case_insensitive_compare(a, b)
	return string.lower(a) < string.lower(b)
end

-- Lines 57-76
function string.split(s, separator_pattern, keep_empty, max_splits)
	local result = {}
	local pattern = "(.-)" .. separator_pattern .. "()"
	local count = 0
	local final_match_end_index = 0

	for part, end_index in string.gmatch(s, pattern) do
		final_match_end_index = end_index

		if keep_empty or part ~= "" then
			count = count + 1
			result[count] = part

			if count == max_splits then
				break
			end
		end
	end

	local remainder = string.sub(s, final_match_end_index)
	result[count + 1] = (keep_empty or remainder ~= "") and remainder or nil

	return result
end

-- Lines 78-87
function string.join(separator, elements, keep_empty)
	local strings = table.collect(elements, function (element)
		local as_string = tostring(element)

		if as_string ~= "" or keep_empty then
			return as_string
		end
	end)

	return table.concat(strings, separator)
end

-- Lines 89-92
function string.trim(s, pattern)
	pattern = pattern or "%s*"

	return string.match(s, "^" .. pattern .. "(.-)" .. pattern .. "$")
end

-- Lines 94-96
function string.capitalize(s)
	return string.gsub(s, "(%w)(%w*)", function (first_letter, remaining_letters)
		return string.upper(first_letter) .. string.lower(remaining_letters)
	end)
end

-- Lines 98-101
function string.pretty(s, capitalize)
	local pretty = string.gsub(s, "%W", " ")

	return capitalize and string.capitalize(pretty) or pretty
end

-- Lines 103-107
function string:rep(n)
	local out = ""

	for i = 1, n do
		out = out .. self
	end

	return out
end

-- Lines 109-111
function string:left(n)
	return self .. (" "):rep(n - self:len())
end
