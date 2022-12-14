##aoc
@variables+=
local test_input = [[
498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
]]
local answer_test1 = 24

@parts+=
function part1(lines)
	@local_variables
	@create_terrain
	@simulate_sand_falling_until_flow_out
	@show_answer
	return answer
end

@create_terrain+=
for _, line in ipairs(lines) do
	@split_into_pairs
	@foreach_pair_draw_line
end


@split_into_pairs+=
local pairs = vim.split(line, "->")

@foreach_pair_draw_line+=
for i=1,#pairs-1 do
	local x1, y1 = unpack(vim.split(pairs[i], ","))
	local x2, y2 = unpack(vim.split(pairs[i+1], ","))

	x1 = tonumber(x1)
	y1 = tonumber(y1)
	x2 = tonumber(x2)
	y2 = tonumber(y2)

	@draw_line_in_terrain
end


@functions+=
function copysign(sign, ref) 
	if sign < 0 then return -ref
	elseif sign == 0 then return 0 end
	return ref
end

@draw_line_in_terrain+=
local len = math.abs(x1 - x2) + math.abs(y1 - y2)
local disp = {
	copysign(x2 - x1, 1),
	copysign(y2 - y1, 1)
}

local pos = { x1, y1 }

for i=1,len+1 do
	@draw_cell
	pos[1] = pos[1] + disp[1]
	pos[2] = pos[2] + disp[2]
end

@local_variables+=
local grid = {}

@draw_cell+=
grid[pos[1]] = grid[pos[1]] or {}
grid[pos[1]][pos[2]] = true
@save_bottommost_block

@variables+=
local bottom = -math.huge

@save_bottommost_block+=
bottom = math.max(bottom, pos[2])

@simulate_sand_falling_until_flow_out+=
local answer = 0
while true do
	local pos = { 500, 0 }
	local stop = false
	while true do
		@if_sand_below_bottom_stop
		@advance_sand_below
	end
	if stop then
		break
	end
	answer = answer + 1 
end

@if_sand_below_bottom_stop+=
if pos[2] > bottom then
	stop = true
	break
end

@advance_sand_below+=
if not grid[pos[1]] or not grid[pos[1]][pos[2]+1] then
	pos[2] = pos[2] + 1
elseif not grid[pos[1]-1] or not grid[pos[1]-1][pos[2]+1] then
	pos[1] = pos[1] - 1
	pos[2] = pos[2] + 1
elseif not grid[pos[1]+1] or not grid[pos[1]+1][pos[2]+1] then
	pos[1] = pos[1] + 1
	pos[2] = pos[2] + 1
else
	grid[pos[1]] = grid[pos[1]] or {}
	grid[pos[1]][pos[2]] = true
	break
end

@show_answer+=
print(answer)
