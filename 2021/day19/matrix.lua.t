##matrix
@matrix.lua=
local Matrix = { 
	__index = {
		@matrix_methods
	},
	@matrix_metamethods
}

function Mat(rows)
	local o
	@if_rows_is_number_create_identity_matrix
	else
		o = {
			rows = rows,
			m = #rows,
			n = #rows[1],
			is_matrix = true,
		}
	end

	return setmetatable(o, Matrix)
end

@vec

@matrix_metamethods+=
__tostring = function(mat)
	local result = {}
	for _,row in ipairs(mat.rows) do
		table.insert(result, "[" .. table.concat(row, " ") .. "]")
	end
	return "[" .. table.concat(result, " ") .. "]"
end,

@if_matrix_put_virtual_text+=
if type(v) == "table" and v.is_matrix then
	vim.api.nvim_buf_set_virtual_text( 0, vnamespace, d.lnum-1, {{ tostring(v), "Special" }}, {})
end

@matrix_metamethods+=
__add = function(a, b)
	assert(a.m == b.m and a.n == b.n, "(add) Matrix dimensions mismatch")

	local result = {}
	for i=1,a.m do
		local row = {}
		for j=1,a.n do
			table.insert(row, a.rows[i][j]+b.rows[i][j])
		end
		table.insert(result, row)
	end
	return Mat(result)
end,

__sub = function(a, b)
	assert(a.m == b.m and a.n == b.n, "(sub) Matrix dimensions mismatch")

	local result = {}
	for i=1,a.m do
		local row = {}
		for j=1,a.n do
			table.insert(row, a.rows[i][j]-b.rows[i][j])
		end
		table.insert(result, row)
	end
	return Mat(result)
end,

__mul = function(a, b)
	if type(a) == "number" then
		@do_matrix_multiplication_coefficient_left
	elseif type(b) == "number" then
		@do_matrix_multiplication_coefficient_right
	else
		@do_matrix_matrix_multiplication
	end

end,

@do_matrix_multiplication_coefficient_left+=
local result = {}
for i=1,b.m do
	local row = {}
	for j=1,b.n do
		table.insert(row, a*b.rows[i][j])
	end
	table.insert(result, row)
end
return Mat(result)

@do_matrix_multiplication_coefficient_right+=
local result = {}
for i=1,a.m do
	local row = {}
	for j=1,a.n do
		table.insert(row, a.rows[i][j]*b)
	end
	table.insert(result, row)
end
return Mat(result)

@do_matrix_matrix_multiplication+=
assert(a.n == b.m, "(mul) Matrix dimensions mismatch")

local result = {}
for i=1,a.m do
	local row = {}
	for j=1,b.n do
		local sum = 0
		for k=1,a.n do 
			sum = sum + a.rows[i][k]*b.rows[k][j]
		end
		table.insert(row, sum)
	end
	table.insert(result, row)
end
return Mat(result)

@if_rows_is_number_create_identity_matrix+=
if type(rows) == "number" then
	local n = rows
	local result = {}
	for i=1,n do
		local row = {}
		for j=1,n do
			local cell = 0
			if i == j then cell = 1 end
			table.insert(row, cell)
		end
		table.insert(result, row)
	end

	o = { 
		m = n,
		n = n,
		rows = result,
		is_matrix = true,
	}

@vec+=
function Vec(col)
	local result = {}
	for _, i in ipairs(col) do
		table.insert(result, { i })
	end
	local o = {
		m = #col,
		n = 1,
		rows = result,
		is_matrix = true,
	}

	return setmetatable(o, Matrix)
end

@matrix_methods+=
transpose = function(self) 
	local result = {}
	for i=1,self.n do
		local row = {}
		for j=1,self.m do
			table.insert(row, self.rows[j][i])
		end
		table.insert(result, row)
	end
	return Mat(result)
end,
apply = function(self, f) 
	local result = {}
	for i=1,self.m do
		local row = {}
		for j=1,self.n do
			table.insert(row, f(self.rows[i][j]))
		end
		table.insert(result, row)
	end
	return Mat(result)
end,
el_mul = function(self, other)
	local result = {}
	for i=1,self.m do
		local row = {}
		for j=1,self.n do
			table.insert(row, self.rows[i][j] * other.rows[i][j])
		end
		table.insert(result, row)
	end
	return Mat(result)
end,
sum_all = function(self)
  local sum = 0
	for i=1,self.m do
		for j=1,self.n do
			sum = sum + self.rows[i][j]
		end
	end
  return sum
end,
trace = function(self)
  assert(self.n == self.m)
  local sum = 0
	for i=1,self.m do
    sum = sum + self.rows[i][i]
  end
  return sum
end,
copy = function(self) 
	local result = {}
	for i=1,self.m do
		local row = {}
		for j=1,self.n do
			table.insert(row, self.rows[i][j])
		end
		table.insert(result, row)
	end
	return Mat(result)
end,
l1_norm = function(self) 
	local norm = 0
	for i=1,self.m do
		for j=1,self.n do
			norm = norm + math.abs(self.rows[i][j])
		end
	end
  return norm
end,
cross = function(self, other) 
  assert(self.m == 3 and self.n == 1, "self must be 3x1 matrix")
  assert(other.m == 3 and other.n == 1, "other must be 3x1 matrix")
	local result = Vec { 0, 0, 0 }
  result.rows[1][1] = self.rows[2][1]*other.rows[3][1] - self.rows[3][1]*other.rows[2][1]
  result.rows[2][1] = self.rows[3][1]*other.rows[1][1] - self.rows[1][1]*other.rows[3][1]
  result.rows[3][1] = self.rows[1][1]*other.rows[2][1] - self.rows[2][1]*other.rows[1][1]
  return result
end,
hconcat = function(self, other)
  assert(self.m == other.m, "hconcat self and other must have same number of line")
  local rows = {}
  for i=1,self.m do
    local row = {}
    @append_elem_to_row_for_concat
    table.insert(rows, row)
  end
  return Mat(rows)
end,

@append_elem_to_row_for_concat+=
for j=1,self.n do
  table.insert(row, self.rows[i][j])
end

for j=1,other.n do
  table.insert(row, other.rows[i][j])
end

@matrix_methods+=
unpack = function(self)
  assert(self.n == 1, "self must be a column vector")
  assert(self.m >= 2 and self.m <= 4, "self must be a column vector of 2-3 rows")
  if self.m == 2 then
    return self.rows[1][1],self.rows[2][1]
  elseif self.m == 3 then
    return self.rows[1][1],self.rows[2][1],self.rows[3][1]
  elseif self.m == 4 then
    return self.rows[1][1],self.rows[2][1],self.rows[3][1],self.rows[4][1]
  end
end
