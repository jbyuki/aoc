##aoc
@variables+=
local answer_test2 = 5031

@parts+=
function part2(lines, istest)
	@local_variables
	@parse_input
	@find_start_location
	@init_movements_map
	@move_on_cube
	@compute_password_with_finish_position

	-- @show_movement_map
	-- @draw_edge_map
	return answer
end

@move_on_cube+=
local rest = path
while #rest > 0 do
	@read_next_instruction
	@if_instruction_is_turning
	@if_instruction_is_walking_cube
end

@if_instruction_is_walking_cube+=
elseif steps then
	for i=1,steps do
		@if_border_wrap_if_possible_on_cube
		@if_free_advance
		@otherwise_stop
	end
else
	assert(false)
end

@if_border_wrap_if_possible_on_cube+=
local drow, dcol = unpack(dgrid[dir])

if not inside(drow+row, col+dcol, N, M) or grid[drow+row][col+dcol] == " " or not grid[drow+row][col+dcol] then
	local warprow, warpcol
	local newdir
	@find_border_on_opposite_side_of_cube
	assert(warprow and warpcol and newdir)
	@if_free_advance_there_cube

@find_border_on_opposite_side_of_cube+=
if istest then
	@find_in_which_square_test

	@test_one_to_three
	@test_one_to_two
	@test_one_to_six

	@test_two_to_one
	@test_two_to_six
	@test_two_to_five

	@test_three_to_one
	@test_three_to_five

	@test_four_to_six

	@test_five_to_three
	@test_five_to_two

	@test_six_to_four
	@test_six_to_one
	@test_six_to_two
else
--              ┌────────┬─────────┐
--              │        │         │
--              │   1    │    2    │
--              │        │         │
--              ├────────┼─────────┘
--              │        │
--              │        │
--              │   3    │
--              │        │
--     ┌────────┼────────┤
--     │        │        │
--     │   5    │   4    │
--     │        │        │
--     │        │        │
--     ├────────┼────────┘
--     │        │
--     │   6    │
--     │        │
--     │        │
--     └────────┘
--
-- sides are length 50
	@find_in_which_square_input

	@input_one_to_six
	@input_one_to_five

	@input_two_to_three
	@input_two_to_four
	@input_two_to_six

	@input_three_to_five
	@input_three_to_two

	@input_four_to_two
	@input_four_to_six

	@input_five_to_three
	@input_five_to_one
	
	@input_six_to_four
	@input_six_to_two
	@input_six_to_one
end

@find_in_which_square_test+=
local sqrow = math.floor((row-1)/4) + 1
local sqcol = math.floor((col-1)/4) + 1
local which_square = {}
which_square[1] = { [3] = 1 }
which_square[2] = { [1] = 2, [2] = 3, [3] = 4 }
which_square[3] = { [3] = 5, [4] = 6 }
local square_pos = {}
square_pos[1] = { 1, 3 }
square_pos[2] = { 2, 1 }
square_pos[3] = { 2, 2 }
square_pos[4] = { 2, 3 }
square_pos[5] = { 3, 3 }
square_pos[6] = { 3, 4 }
local side = 4
for _, sqpos in ipairs(square_pos) do
	sqpos[1] = (sqpos[1]-1) * side + 1
	sqpos[2] = (sqpos[2]-1) * side + 1
end
assert(which_square[sqrow] and which_square[sqrow][sqcol])
local square = which_square[sqrow][sqcol]

@test_one_to_three+=
if square == 1 and dcol == -1 then
	warprow = square_pos[3][1]
	warpcol = square_pos[3][2] + (row - square_pos[1][1])
	newdir = "down"
@test_one_to_two+=
elseif square == 1 and drow == -1 then
	warprow = square_pos[2][1]
	warpcol = square_pos[2][2] + (side-1) - (col - square_pos[1][2])
	newdir = "down"
@test_one_to_six+=
elseif square == 1 and dcol == 1 then
	warprow = square_pos[6][1] + (side-1) - (row - square_pos[1][1])
	warpcol = square_pos[6][2] + (side-1)
	newdir = "left"

@test_two_to_one+=
elseif square == 2 and drow == -1 then
	warprow = square_pos[1][1]
	warpcol = square_pos[1][2] + (side-1) - (col - square_pos[2][2])
	newdir = "down"
@test_two_to_six+=
elseif square == 2 and dcol == -1 then
	warprow = square_pos[6][1] + (side-1)
	warpcol = square_pos[6][2] + (side-1) - (row - square_pos[2][1])
	newdir = "up"
@test_two_to_five+=
elseif square == 2 and drow == 1 then
	warprow = square_pos[5][1] + (side-1)
	warpcol = square_pos[5][2] + (side-1) - (col - square_pos[2][2])
	newdir = "up"

@test_three_to_one+=
elseif square == 3 and drow == -1 then
	warprow = square_pos[1][1] + (col - square_pos[3][2])
	warpcol = square_pos[1][2]
	newdir = "right"
@test_three_to_five+=
elseif square == 3 and drow == 1 then
	warprow = square_pos[5][1] + (side-1) - (col - square_pos[3][2])
	warpcol = square_pos[5][2]
	newdir = "right"

@test_four_to_six+=
elseif square == 4 and dcol == 1 then
	warprow = square_pos[6][1]
	warpcol = square_pos[6][2] + (side-1) - (row - square_pos[4][1])
	newdir = "down"

@test_five_to_three+=
elseif square == 5 and dcol == -1 then
	warprow = square_pos[3][1] + (side-1)
	warpcol = square_pos[3][2] + (side-1) - (row - square_pos[5][1])
	newdir = "up"
@test_five_to_two+=
elseif square == 5 and drow == 1 then
	warprow = square_pos[2][1] + (side-1)
	warpcol = square_pos[2][2] + (side-1) - (col - square_pos[5][2])
	newdir = "up"

@test_six_to_four+=
elseif square == 6 and drow == -1 then
	warprow = square_pos[4][1] + (side-1) - (col - square_pos[6][2])
	warpcol = square_pos[4][2]
	newdir = "right"
@test_six_to_one+=
elseif square == 6 and dcol == 1 then
	warprow = square_pos[1][1] + (side-1) - (row - square_pos[6][1])
	warpcol = square_pos[1][2] + (side-1)
	newdir = "left"
@test_six_to_two+=
elseif square == 6 and drow == 1 then
	warprow = square_pos[2][1] + (side-1) - (col - square_pos[6][2])
	warpcol = square_pos[2][2]
	newdir = "right"
end

@if_free_advance_there_cube+=
if grid[warprow][warpcol] == "." then
	-- @draw_move
	-- @draw_border_move
	row = warprow
	col = warpcol
	dir = newdir
end

@local_variables+=
local letter = ("A"):byte()

@draw_border_move+=
if grid[warprow][warpcol] == "." then
	if letter < ("Z"):byte() then
		moves[row][col] = string.char(letter)
		moves[warprow][warpcol] = string.char(letter)
		letter = letter + 1
	end
end

@find_in_which_square_input+=
local side = 50
local sqrow = math.floor((row-1)/side) + 1
local sqcol = math.floor((col-1)/side) + 1
local which_square = {}
which_square[1] = { [2] = 1, [3] = 2 }
which_square[2] = { [2] = 3 }
which_square[3] = { [1] = 5, [2] = 4 }
which_square[4] = { [1] = 6 }
local square_pos = {}
square_pos[1] = { 1, 2 }
square_pos[2] = { 1, 3 }
square_pos[3] = { 2, 2 }
square_pos[4] = { 3, 2 }
square_pos[5] = { 3, 1 }
square_pos[6] = { 4, 1 }
for _, sqpos in ipairs(square_pos) do
	sqpos[1] = (sqpos[1]-1) * side + 1
	sqpos[2] = (sqpos[2]-1) * side + 1
end
assert(which_square[sqrow] and which_square[sqrow][sqcol])
local square = which_square[sqrow][sqcol]

@input_one_to_six+=
if square == 1 and drow == -1 then
	warprow = square_pos[6][1] + (col - square_pos[1][2])
	warpcol = square_pos[6][2]
	newdir = "right"
@input_one_to_five+=
elseif square == 1 and dcol == -1 then
	warprow = square_pos[5][1] + (side-1) - (row - square_pos[1][1])
	warpcol = square_pos[5][2]
	newdir = "right"

@input_two_to_three+=
elseif square == 2 and drow == 1 then
	warprow = square_pos[3][1] + (col - square_pos[2][2])
	warpcol = square_pos[3][2] + (side-1)
	newdir = "left"
@input_two_to_four+=
elseif square == 2 and dcol == 1 then
	warprow = square_pos[4][1] + (side-1) - (row - square_pos[2][1])
	warpcol = square_pos[4][2] + (side-1)
	newdir = "left"
@input_two_to_six+=
elseif square == 2 and drow == -1 then
	warprow = square_pos[6][1] + (side-1)
	warpcol = square_pos[6][2] + (col - square_pos[2][2])
	newdir = "up"

@input_three_to_five+=
elseif square == 3 and dcol == -1 then
	warprow = square_pos[5][1] 
	warpcol = square_pos[5][2] + (row - square_pos[3][1])
	newdir = "down"
@input_three_to_two+=
elseif square == 3 and dcol == 1 then
	warprow = square_pos[2][1] + (side-1)
	warpcol = square_pos[2][2] + (row - square_pos[3][1])
	newdir = "up"

@input_four_to_two+=
elseif square == 4 and dcol == 1 then
	warprow = square_pos[2][1] + (side-1) - (row - square_pos[4][1])
	warpcol = square_pos[2][2] + (side-1)  
	newdir = "left"
@input_four_to_six+=
elseif square == 4 and drow == 1 then
	warprow = square_pos[6][1] + (col - square_pos[4][2])
	warpcol = square_pos[6][2] + (side-1)  
	newdir = "left"

@input_five_to_three+=
elseif square == 5 and drow == -1 then
	warprow = square_pos[3][1] + (col - square_pos[5][2])
	warpcol = square_pos[3][2]
	newdir = "right"
@input_five_to_one+=
elseif square == 5 and dcol == -1 then
	warprow = square_pos[1][1] + (side-1) - (row - square_pos[5][1])
	warpcol = square_pos[1][2]
	newdir = "right"

@input_six_to_four+=
elseif square == 6 and dcol == 1 then
	warprow = square_pos[4][1] + (side-1)
	warpcol = square_pos[4][2] + (row - square_pos[6][1])
	newdir = "up"
@input_six_to_two+=
elseif square == 6 and drow == 1 then
	warprow = square_pos[2][1]
	warpcol = square_pos[2][2] + (col - square_pos[6][2])
	newdir = "down"
@input_six_to_one+=
elseif square == 6 and dcol == -1 then
	warprow = square_pos[1][1]
	warpcol = square_pos[1][2] + (row - square_pos[6][1])
	newdir = "down"
end

@draw_edge_map+=
if not istest then
	local edge_map = vim.deepcopy(grid)
	@find_in_which_square_input

	letter = ("A"):byte()
	for sq=1,6 do
		for _, delta in ipairs({{1, 0}, {-1, 0}, {0, -1}, {0, 1}}) do
			local drow, dcol = unpack(delta)
			@draw_edge_in_source_square_and_destination
		end
	end
	@show_edge_map
end

@draw_edge_in_source_square_and_destination+=
local up = square_pos[sq][1]
local left = square_pos[sq][2]

for i=1,side do
	@find_source_position
	@find_destination_position
	@draw_source_and_destination_in_map
end

@find_source_position+=
local row, col
if drow == 1 then
	row = up + (side-1)
	col = left + (i-1)
elseif drow == -1 then
	row = up
	col = left + (i-1)
elseif dcol == -1 then
	row = up + (i-1)
	col = left
elseif dcol == 1 then
	row = up + (i-1)
	col = left + (side-1)
end

@find_destination_position+=
local warprow, warpcol, newdir
@find_in_which_square_input

@input_one_to_six
@input_one_to_five

@input_two_to_three
@input_two_to_four
@input_two_to_six

@input_three_to_five
@input_three_to_two

@input_four_to_two
@input_four_to_six

@input_five_to_three
@input_five_to_one

@input_six_to_four
@input_six_to_two
@input_six_to_one

@draw_source_and_destination_in_map+=
if warprow and warpcol then
	if i == 1 or i == math.floor(side/2) then
		letter = letter + 1
	end

	edge_map[row][col] = string.char(letter)
	if newdir == "up" then
		warprow = warprow - 1
	elseif newdir == "down" then
		warprow = warprow + 1
	elseif newdir == "left" then
		warpcol = warpcol - 1
	elseif newdir == "right" then
		warpcol = warpcol + 1
	end
	edge_map[warprow][warpcol] = string.char(letter)
end


@show_edge_map+=
for _, row in ipairs(edge_map) do
	print(table.concat(row, ""))
end
