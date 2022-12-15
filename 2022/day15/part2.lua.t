##aoc
@variables+=
local answer_test2 = 56000011

@parts+=
function part2(lines, istest)
	@local_variables
	@parse_input
	for _, s in ipairs(sensors) do
		local sx, sy, bx, by = unpack(s)
		@transform_to_rectangular_constraints
		@add_rectangular_range
	end
	@find_only_possible_solution
	return answer
end

@transform_to_rectangular_constraints+=
local dist = math.abs(bx-sx) + math.abs(by-sy)

@project_onto_x_axis
@project_onto_y_axis

@project_onto_x_axis+=
local x1 = sx - dist - sy
local x2 = sx + dist - sy

@project_onto_y_axis+=
local y1 = sy - dist + sx
local y2 = sy + dist + sx

@functions+=
function insert_range(x_marks, y_marks, filled, x1, x2, y1, y2)
	@add_marks_x
	@add_marks_y
	@fill_range
end

@add_marks_x+=
local function add_x_mark(x)
	local i = 1
	while i <= #x_marks and x > x_marks[i] do
		i = i + 1
	end
	if x_marks[i] == x then return i end
	table.insert(x_marks, i, x)
	table.insert(filled, i, vim.deepcopy(filled[i]))
	return i
end

local x1i = add_x_mark(x1*2-1)
local x2i = add_x_mark(x2*2+1)

@add_marks_y+=
local function add_y_mark(y)
	local i = 1
	while i <= #y_marks and y > y_marks[i] do
		i = i + 1
	end
	if i <= #y_marks and y_marks[i] == y then return i end
	table.insert(y_marks, i, y)
	for j=1,#filled do
		table.insert(filled[j], i, filled[j][i])
	end
	return i
end

local y1i = add_y_mark(y1*2-1)
local y2i = add_y_mark(y2*2+1)

@fill_range+=
for i=x1i+1,x2i do
	for j=y1i+1,y2i do
		filled[i][j] = true
	end
end

@local_variables+=
local x_marks = {}
local y_marks = {}
local filled = { { false } }

@add_rectangular_range+=
insert_range(x_marks, y_marks, filled, x1, x2, y1, y2)

@functions+=
function find_index(marks, x)
	for i=1,#marks do
		if x < marks[i] then
			return i
		end
	end
end

@find_only_possible_solution+=
local x
local y

for i=1,#filled do
	for j=2,#filled[i]-1 do
		if filled[i][j] == false and filled[i][j-1] == true and filled[i][j+1] == true then
			local projx = x_marks[i]
			local projy = y_marks[j]
			projx = math.floor((projx-1)/2)
			projy = math.floor((projy-1)/2)
			x = (projx+projy)/2
			y = ((-projx)+projy)/2
			break
		end
	end
end

local answer = 4000000 * x + y
