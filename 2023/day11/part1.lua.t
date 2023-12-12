##aoc
@variables+=
local test_input1 = [[
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
]]

local answer_test1 = 374

@parts+=
@define_functions
function part1(lines, istest)
	local answer
	@local_variables
	@find_location_of_galaxies
	@find_empty_rows
	@find_empty_cols
	@expand_location_galaxies
	@compute_pairwise_distances
	return answer
end

@find_location_of_galaxies+=
local locs = {}
for i,line in ipairs(lines) do
	for j=1,#line do
		if line:sub(j,j) == "#" then
			table.insert(locs, {i,j})
		end
	end
end

@find_empty_rows+=
local empty_rows = {}
for i,line in ipairs(lines) do
	if not line:find("#") then
		table.insert(empty_rows, i)
	end
end

@find_empty_cols+=
local empty_cols = {}
for j=1,#lines[1] do
	local empty = true
	for _, line in ipairs(lines) do
		if line:sub(j,j) == "#" then
			empty = false
			break
		end
	end

	if empty then
		table.insert(empty_cols, j)
	end
end

@expand_location_galaxies+=
for i=1,#locs do
	local r,c = unpack(locs[i])
	@increment_row
	@increment_col
	locs[i] = {r,c}
end

@increment_row+=
local inc = 0
for _,rr in ipairs(empty_rows) do
	if rr < r then
		inc = inc + 1
	else
		break
	end
end

r = r + inc

@increment_col+=
local inc = 0
for _,cc in ipairs(empty_cols) do
	if cc < c then
		inc = inc + 1
	else
		break
	end
end
c = c + inc

@compute_pairwise_distances+=
local answer = 0
for i=1,#locs do
	for j=i+1,#locs do
		local r1, c1 = unpack(locs[i])
		local r2, c2 = unpack(locs[j])
		answer = answer + math.abs(r1-r2) + math.abs(c1-c2)
	end
end


