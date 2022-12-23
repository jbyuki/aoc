##aoc
@variables+=
local test_input = [[
        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5
]]
local answer_test1 = 6032

@parts+=
function part1(lines, istest)
	@local_variables
	@parse_input
	@find_start_location
	@init_movements_map
	@move_according_to_rules
	@compute_password_with_finish_position
	-- @show_movement_map
	return answer
end

@parse_input+=
local text = table.concat(lines, "\n")
grid, path  = unpack(vim.split(text, "\n\n"))
grid = vim.split(grid, "\n")
for i=1,#grid do
	grid[i] = vim.split(grid[i], "")
end

@local_variables+=
local row = 1
local col = 1
local dir = "right"
local dirmap = { "right", "down", "left", "up" }
vim.tbl_add_reverse_lookup(dirmap)

@find_start_location+=
local N = #grid
local M = 0
for i=1,#grid do
	M = math.max(M, #grid[i])
end

for i=1,M do
	if grid[1][i] == "." then
		col = i
		break
	end
end

@move_according_to_rules+=
local rest = path
while #rest > 0 do
	@read_next_instruction
	@if_instruction_is_turning
	@if_instruction_is_walking
end

@read_next_instruction+=
local steps, turn
if rest:match("^%d") then
	steps = rest:match("^(%d+)")
	rest = rest:sub(#steps+1)
	steps = tonumber(steps)
else
	turn = rest:sub(1,1)
	rest = rest:sub(2)
end

@if_instruction_is_turning+=
if turn == "R" then
	dir = dirmap[((dirmap[dir]+1)-1)%4+1]

elseif turn == "L" then
	dir = dirmap[((dirmap[dir]-1)-1)%4+1]

@if_instruction_is_walking+=
elseif steps then
	for i=1,steps do
		@if_border_wrap_if_possible
		@if_free_advance
		@otherwise_stop
	end
else
	assert(false)
end

@local_variables+=
local dgrid = {
	["up"] = { -1, 0 },
	["down"] = { 1, 0 },
	["left"] = { 0, -1 },
	["right"] = { 0, 1 },
}

@functions+=
function inside(i, j, N, M)
	return i >= 1 and i <= N and j >= 1 and j <= M
end

@if_border_wrap_if_possible+=
local drow, dcol = unpack(dgrid[dir])

if not inside(drow+row, col+dcol, N, M) or grid[drow+row][col+dcol] == " " or not grid[drow+row][col+dcol] then
	@find_fartest_on_opposite_side
	@if_free_advance_there

@find_fartest_on_opposite_side+=
local warprow = row
local warpcol = col

local srow = row
local scol = col

assert(inside(srow, scol, N, M))

while inside(srow, scol, N, M) do
	if grid[srow][scol] == "." or grid[srow][scol] == "#" then
		warprow = srow
		warpcol = scol
	end

	srow = srow - drow
	scol = scol - dcol
end

assert(warprow ~= row or warpcol ~= col)

@if_free_advance_there+=
if grid[warprow][warpcol] == "." then
	@draw_move
	row = warprow
	col = warpcol
else
	break
end

@if_free_advance+=
elseif grid[drow+row][col+dcol] == "." then
	-- @draw_move
	row = drow+row
	col = dcol+col

@otherwise_stop+=
else
	break
end

@compute_password_with_finish_position+=
local answer = 1000*row + 4*col + (dirmap[dir]-1)

@init_movements_map+=
local moves = vim.deepcopy(grid)

@local_variables+=
local arrow = {
	["right"] = ">",
	["down"] = "v",
	["left"] = "<",
	["up"] = "^",
}

@draw_move+=
moves[row][col] = arrow[dir]

@show_movement_map+=
moves[row][col] = arrow[dir]

for _, row in ipairs(moves) do
	print(table.concat(row, ""))
end
