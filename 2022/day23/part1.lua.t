##aoc
@variables+=
local test_input = [[
  ....#..
  ..###.#
  #...#.#
  .#...##
  #.###..
  ##.#.##
  .#..#..
]]

local answer_test1 = 110

@parts+=
function part1(lines, istest)
	@local_variables
	@parse_grid
	@init_states
	@simulate_according_to_rules
	@show_answer
	return answer
end

@parse_grid+=
local grid = {}
for i=1,#lines do
	local row = vim.split(vim.trim(lines[i]), "")
	table.insert(grid, row)
end

local N = #grid
local M = #grid[1]
print(N,M)

@simulate_according_to_rules+=
local round = 1
while true do
	@first_phase
	@second_phase
	@if_none_moved_break
	@compute_minimum_bounding_rect_empty_grounds
	@next_direction_to_consider
	round = round + 1
end

@first_phase+=
for i=mini,maxi do
	for j=minj,maxj do
		if grid[i] and grid[i][j] and grid[i][j] == "#" then
			@check_if_all_free
			@otherwise_check_for_first_direction
		end
	end
end

@functions+=
function inside(i,j,N,M) 
	return i >= 1 and i <= N and j >= 1 and j <= M
end

@check_if_all_free+=
local all_free = true
for di=-1,1 do
	for dj=-1,1 do
		if di ~= 0 or dj ~= 0 then
			if grid[i+di] and grid[i+di][j+dj] == "#" then
				all_free = false
				break
			end
		end
	end
end

@otherwise_check_for_first_direction+=
if not all_free then
	@get_direction_to_check_from_list
	@free_variable
	for k=1,4 do
		@check_for_direction
		dir = dir_order[(dir_order[dir])%4+1]
	end
	@mark_potentential_destination
end

@local_variables+=
local dir_order = {
	"north", "south", "west", "east"
}
vim.tbl_add_reverse_lookup(dir_order)
local next_dir = 1

@next_direction_to_consider+=
next_dir = next_dir%4+1

@get_direction_to_check_from_list+=
local dir = dir_order[next_dir]

@local_variables+=
local check_which = {
	["north"] = {{-1, -1}, {-1, 0}, {-1, 1}},
	["south"] = {{1, -1}, {1, 0}, {1, 1}},
	["west"] = {{1, -1}, {0, -1}, {-1, -1}},
	["east"] = {{-1, 1}, {0, 1}, {1, 1}},

}

@check_for_direction+=
local free = true
for _, delta in ipairs(check_which[dir]) do
	local di, dj = unpack(delta)
	if grid[i+di] and grid[i+di][j+dj] and grid[i+di][j+dj] == "#" then
		free = false
	end
end
if free then
	found_free = true
	break
end

@free_variable+=
local found_free = false

@first_phase-=
local occupancy = {}
local next_pos = {}

@local_variables+=
local move = {
	["north"] = { -1, 0 },
	["south"] = { 1, 0 },
	["west"] = { 0, -1 },
	["east"] = { 0, 1 },
}

@mark_potentential_destination+=

if found_free then
	local di, dj = unpack(move[dir])
	occupancy[i+di] = occupancy[i+di] or {}
	occupancy[i+di][j+dj] = occupancy[i+di][j+dj] or 0
	occupancy[i+di][j+dj] = occupancy[i+di][j+dj] + 1

	next_pos[i] = next_pos[i] or {}
	next_pos[i][j] = { i+di, j+dj }
end

@second_phase+=
for i=mini,maxi do
	for j=minj,maxj do
		if grid[i] and grid[i][j] and grid[i][j] == "#" and next_pos[i] and next_pos[i][j] then
			@check_if_only_one_to_move_if_so_move
		end
	end
end

@second_phase-=
local has_moved = false

@check_if_only_one_to_move_if_so_move+=
local ni, nj = unpack(next_pos[i][j])
if occupancy[ni][nj] == 1 then
	grid[ni] = grid[ni] or {}
	grid[ni][nj] = "#"
	@update_bounds
	grid[i][j] = "."
	has_moved = true
end

@if_none_moved_break+=
if not has_moved then
	break
end

@draw_grid+=
for i=mini, maxi do
	local row = {}
	for j=minj, maxj do
		if grid[i] and grid[i][j] then
			table.insert(row, grid[i][j])
		else
			table.insert(row, ".")
		end
	end
	print(table.concat(row))
end

@local_variables+=
local smallest_rect = math.huge

local mini = math.huge
local minj = math.huge
local maxi = -math.huge
local maxj = -math.huge

@init_states+=
for i=1,N do
	for j=1,M do
		if grid[i][j] == "#" then
			mini = math.min(mini, i)
			minj = math.min(minj, j)
			maxi = math.max(maxi, i)
			maxj = math.max(maxj, j)
		end
	end
end 

@update_bounds+=
mini = math.min(mini, ni)
minj = math.min(minj, nj)
maxi = math.max(maxi, ni)
maxj = math.max(maxj, nj)

@local_variables+=
local check_empty

@compute_minimum_bounding_rect_empty_grounds+=
if round == 10 then
	local empty = 0
	for i=mini,maxi do
		for j=minj,maxj do
			if not grid[i] or not grid[i][j] or grid[i][j] == "." then
				empty = empty + 1
			end
		end
	end
	check_empty = empty
end

@show_answer+=
local answer = check_empty
