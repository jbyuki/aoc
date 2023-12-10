##aoc
@variables+=
local test_input1 = [[
..F7.
.FJ|.
SJ.L7
|F--J
LJ...
]]

local answer_test1 = 8

@parts+=
@define_functions
function part1(lines, istest)
	local answer
	@local_variables
	@parse_map
	@find_first_tile
	@decide_initial_speed
	@go_around_loop_and_find_distance
	@compute_farthest_distance_in_loop
	return answer
end

@parse_map+=
local map = {}
local rows = #lines
local cols = #lines[1]
local srow
local scol
for i=1,rows do
	for j=1,cols do
		local line = lines[i]
		if line:sub(j,j) == "S" then
			srow = i
			scol = j
			break
		end
	end
end

@variables+=
local connected = {
	-- up, down, left, right
	["|"] = { 1, 1, 0, 0 },
	["-"] = { 0, 0, 1, 1 },
	["L"] = { 1, 0, 0, 1 },
	["J"] = { 1, 0, 1, 0 },
	["7"] = { 0, 1, 1, 0 },
	["F"] = { 0, 1, 0, 1 },
	["."] = { 0, 0, 0, 0 },
}

@define_functions+=
function lookup_rev(con)
	for char, con_map in pairs(connected) do
		@check_if_map_matches
	end
	assert(false)
end

@check_if_map_matches+=
local match = true
for i=1,4 do
	if con_map[i] ~= con[i] then
		match =false
		break
	end
end

if match then
	return char
end

@define_functions+=
function safe_get(lines, row, col) 
	if row < 1 or row > #lines then
		return "."
	elseif col < 1 or col > #lines[1] then
		return "."
	else
		return lines[row]:sub(col,col)
	end
end

@define_functions+=
function lookup(tile)
	return vim.deepcopy(connected[tile])
end

@find_first_tile+=
local up = lookup(safe_get(lines, srow-1, scol))[2]
local down = lookup(safe_get(lines, srow+1, scol))[1]
local left = lookup(safe_get(lines, srow, scol-1))[4]
local right = lookup(safe_get(lines, srow, scol+1))[3]

local tile = lookup_rev({up, down, left, right})


@decide_initial_speed+=
local speed = lookup(tile)
for i=1,4 do
	if speed[i] == 1 then
		speed[i] = 0
		break
	end
end

@go_around_loop_and_find_distance+=
local prow = srow
local pcol = scol
local path_len = 0
while path_len < 100000 do
	@go_to_next_tile
	@if_tile_is_start_end
	@fetch_next_tile
	@fetch_next_speed
end

@go_to_next_tile+=
if speed[1] == 1 then
	prow = prow - 1
elseif speed[2] == 1 then
	prow = prow + 1
elseif speed[3] == 1 then
	pcol = pcol - 1
elseif speed[4] == 1 then
	pcol = pcol + 1
end
path_len = path_len + 1

@if_tile_is_start_end+=
if prow == srow and pcol == scol then
	break
end

@fetch_next_tile+=
tile = safe_get(lines, prow, pcol)
assert(tile ~= ".")

@fetch_next_speed+=
local next_speed = lookup(tile)
@flip_speed

for i=1,4 do
	if speed[i] == 1 and next_speed[i] == 1 then
		next_speed[i] = 0
		break
	end
end

speed = next_speed

@flip_speed+=
if speed[1] == 1 then
	speed[1] = 0
	speed[2] = 1
elseif speed[2] == 1 then
	speed[1] = 1
	speed[2] = 0
elseif speed[3] == 1 then
	speed[3] = 0
	speed[4] = 1
elseif speed[4] == 1 then
	speed[3] = 1
	speed[4] = 0
end

@compute_farthest_distance_in_loop+=
answer = math.floor(path_len / 2)

