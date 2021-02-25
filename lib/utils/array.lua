Array = class()

-- Lines 3-20
function Array:init(data, height, width, name)
	self._name = name

	if width and height then
		self._width = width
		self._height = height
		self._data = data
	else
		self._width = #data[1]
		self._height = #data
		self._data = {}

		for i = 1, self._height do
			local row = data[i]

			for j = 1, self._width do
				self._data[(i - 1) * self._width + j] = row[j]
			end
		end
	end
end

-- Lines 22-24
function Array:name()
	return self._name
end

-- Lines 26-28
function Array:width()
	return self._width
end

-- Lines 30-32
function Array:height()
	return self._height
end

-- Lines 34-36
function Array:data()
	return self._data
end

-- Lines 38-47
function Array:add_row(row)
	local index = self._data and #self._data + 1 or 1

	for _, v in ipairs(row) do
		self._data[index] = v
		index = index + 1
	end

	self._width = self._width and self._width > 0 and self._width or #row
	self._height = self._height + 1

	return self
end

-- Lines 49-64
function Array.from_node(node)
	local width = node:parameter("width")
	local height = node:parameter("height")
	local name = node:parameter("name")

	if width and height then
		width = tonumber(width)
		height = tonumber(height)
		local data = {}
		local items = node:data():split(" ")

		for i, v in ipairs(items) do
			data[i] = tonumber(v)
		end

		return Array:new(data, height, width, name)
	end

	return nil
end

-- Lines 66-74
function Array.random(height, width, out)
	local data = out and out._data or {}
	out = out or Array:new(data, height, width)

	for i = 1, width * height do
		data[i] = 2 * math.random() - 1
	end

	return out
end

-- Lines 76-84
function Array.zero(height, width, out)
	local data = out and out._data or {}
	out = out or Array:new(data, height, width)

	for i = 1, width * height do
		data[i] = 0
	end

	return out
end

-- Lines 86-100
function Array:serialize_thread(name)
	local str = "<array"

	if name then
		str = str .. " name=\"" .. name .. "\""
	end

	str = str .. " width=\"" .. tostring(self._width) .. "\" height=\"" .. tostring(self._height) .. "\"><![CDATA["

	for i = 1, self._width * self._height do
		str = str .. " " .. tostring(self._data[i])

		if i % 100 == 0 then
			coroutine.yield()
		end
	end

	str = str .. " ]]></array>"

	return str
end

-- Lines 102-113
function Array:serialize(name)
	local str = "<array"

	if name then
		str = str .. " name=\"" .. name .. "\""
	end

	str = str .. " width=\"" .. tostring(self._width) .. "\" height=\"" .. tostring(self._height) .. "\"><![CDATA["

	for i = 1, self._width * self._height do
		str = str .. " " .. tostring(self._data[i])
	end

	str = str .. " ]]></array>"

	return str
end

-- Lines 115-143
function Array:dot(other, out)
	local src = self._data
	local dst = other._data
	local data = out and out._data or {}
	out = out or Array:new(data, self._height, other._width)
	local oindex = 1
	local srowindex = 0

	for i = 1, self._height do
		for j = 1, other._width do
			local v = 0
			local drowindex = 0

			for k = 1, self._width do
				v = v + src[srowindex + k] * dst[drowindex + j]
				drowindex = drowindex + other._width
			end

			data[oindex] = v
			oindex = oindex + 1
		end

		srowindex = srowindex + self._width
	end

	return out
end

-- Lines 145-175
function Array:dot_transpose(other, out)
	local src = self._data
	local dst = other._data
	local data = out and out._data or {}
	out = out or Array:new(data, self._height, other._height)
	local oindex = 1
	local srowindex = 0

	for i = 1, self._height do
		local drowindex = 0

		for j = 1, other._height do
			local v = 0

			for k = 1, self._width do
				v = v + src[srowindex + k] * dst[drowindex + k]
			end

			data[oindex] = v
			oindex = oindex + 1
			drowindex = drowindex + self._width
		end

		srowindex = srowindex + self._width
	end

	return out
end

-- Lines 177-189
function Array:transpose(out)
	local data = out and out._data or {}
	local oindex = 1
	out = out or Array:new(data, self._width, self._height)

	for i = 1, self._width do
		for j = 1, self._height do
			data[oindex] = self._data[(j - 1) * self._width + i]
			oindex = oindex + 1
		end
	end

	return out
end

-- Lines 191-199
function array_tanh(dst, src)
	local dst_data = dst:data()
	local src_data = src:data()

	for i = 1, src:width() * src:height() do
		dst_data[i] = math.tanh(src_data[i])
	end

	return dst
end

-- Lines 201-208
function array_tanh_d(dst, src)
	local dst_data = dst:data()
	local src_data = src:data()

	for i = 1, src:width() * src:height() do
		dst_data[i] = 1 - src_data[i] * src_data[i]
	end

	return dst
end

-- Lines 210-218
function array_logistic(dst, src)
	local dst_data = dst:data()
	local src_data = src:data()

	for i = 1, src:width() * src:height() do
		dst_data[i] = 1 / (1 + math.exp(-src_data[i]))
	end

	return dst
end

-- Lines 220-227
function array_logistic_d(dst, src)
	local dst_data = dst:data()
	local src_data = src:data()

	for i = 1, src:width() * src:height() do
		dst_data[i] = src_data[i] * (1 - src_data[i])
	end

	return dst
end

-- Lines 229-237
function array_relu(dst, src)
	local dst_data = dst:data()
	local src_data = src:data()

	for i = 1, src:width() * src:height() do
		dst_data[i] = math.max(0, src_data[i])
	end

	return dst
end

-- Lines 239-247
function array_relu_d(dst, src)
	local dst_data = dst:data()
	local src_data = src:data()

	for i = 1, src:width() * src:height() do
		local v = src_data[i]
		dst_data[i] = v >= 0 and 1 or 0
	end

	return dst
end

-- Lines 249-257
function array_softplus(dst, src)
	local dst_data = dst:data()
	local src_data = src:data()

	for i = 1, src:width() * src:height() do
		dst_data[i] = math.log(1 + math.exp(src_data[i]))
	end

	return dst
end

-- Lines 259-267
function array_softplus_d(dst, src)
	local dst_data = dst:data()
	local src_data = src:data()

	for i = 1, src:width() * src:height() do
		local v = src_data[i]
		dst_data[i] = 1 / (1 + math.exp(-src_data[i]))
	end

	return dst
end

-- Lines 269-274
function array_sigmoid(dst, src)
	return array_logistic(dst, src)
end

-- Lines 276-281
function array_sigmoid_d(dst, src)
	return array_logistic_d(dst, src)
end

-- Lines 283-290
function array_dropout(dst, src, probability)
	local dst_data = dst:data()
	local src_data = src:data()
	local inv_probability = 1 / probability

	for i = 1, src:width() * src:height() do
		dst_data[i] = src_data[i] * (math.random() < probability and inv_probability or 0)
	end
end

-- Lines 292-302
function array_add(dst, a, b)
	local dst_data = dst:data()
	local a_data = a:data()
	local b_data = b:data()

	for i = 1, a:width() * a:height() do
		dst_data[i] = a_data[i] + b_data[i]
	end

	return dst
end

-- Lines 304-314
function array_mul(dst, a, b)
	local dst_data = dst:data()
	local a_data = a:data()
	local b_data = b:data()

	for i = 1, a:width() * a:height() do
		dst_data[i] = a_data[i] * b_data[i]
	end

	return dst
end

-- Lines 316-325
function array_scalar(dst, a, s)
	local dst_data = dst:data()
	local a_data = a:data()

	for i = 1, a:width() * a:height() do
		dst_data[i] = a_data[i] * s
	end

	return dst
end

-- Lines 327-337
function array_sub(dst, a, b)
	local dst_data = dst:data()
	local a_data = a:data()
	local b_data = b:data()

	for i = 1, a:width() * a:height() do
		dst_data[i] = a_data[i] - b_data[i]
	end

	return dst
end

-- Lines 339-346
function array_mean_error(src)
	local src_data = src:data()
	local err = 0

	for i = 1, src:width() * src:height() do
		err = err + math.abs(src_data[i])
	end

	return err / (src:width() * src:height())
end
