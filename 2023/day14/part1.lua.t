##aoc
@variables+=
local test_input1 = [[
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
]]

local answer_test1 = 136

@parts+=
@define_functions
function part1(lines, istest)
	local answer = 0
	@local_variables
	@tilt_platform
	@compute_load
	return answer
end

@tilt_platform+=
local occupied = {}
@mark_all_stones

@foreach_round_rock_compute_locations

@mark_all_stones+=
for i=1,#lines do
	for j=1,#lines[1] do
		local cell = lines[i]:sub(j,j)
		if cell == "#" then
			occupied[i] = occupied[i] or {}
			occupied[i][j] = true
		end
	end
end

@foreach_round_rock_compute_locations+=
local locs = {}
for i=1,#lines do
	for j=1,#lines[1] do
		local cell = lines[i]:sub(j,j)
		if cell == "O" then
			local r = 0
			while true do
				if r-1+i >= 1 and (not occupied[r-1+i] or not occupied[r-1+i][j]) then
					r = r - 1
				else
					break
				end
			end

			occupied[i+r] = occupied[i+r] or {}
			occupied[i+r][j] = true
			table.insert(locs, i+r)
		end
	end
end


@compute_load+=
local sum = 0
for _,loc in ipairs(locs) do
	sum = sum + (#lines - (loc-1))
end
answer = sum
