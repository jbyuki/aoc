##aoc
@variables+=
local test_input2 = [[
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
]]

@variables+=
local answer_test2 = 10

@parts+=
@define_functions
function part2(lines, istest)
	@local_variables
	@parse_map
	@find_first_tile
	@decide_initial_speed
	@go_around_loop_and_mark_loop
	@find_first_tile
	@decide_initial_speed
	@go_around_loop_and_mark_left_right
	@decide_which_is_outside
	@expand_inside_region
	@find_area_of_inside
	return answer
end

@go_around_loop_and_mark_loop+=
local prow = srow
local pcol = scol
local path_len = 0
while path_len < 1000000 do
	@mark_loop
	@go_to_next_tile
	@if_tile_is_start_end
	@fetch_next_tile
	@fetch_next_speed
end

@go_around_loop_and_mark_left_right+=
local prow = srow
local pcol = scol
local path_len = 0
while path_len < 1000000 do
	@mark_left_right
	@go_to_next_tile
	@if_tile_is_start_end
	@fetch_next_tile
	@fetch_next_speed
end


@define_functions+=
function mark_table(loop, reg, row, col)
	if not loop[row] or not loop[row][col] then
		reg[row] = reg[row] or {}
		reg[row][col] = true
	end
end

@variables+=
local dir = {
	up = 1,
	down = 2,
	left = 3,
	right = 4,
}

@get_origin+=
local origin = vim.deepcopy(speed)

@define_functions+=
function mark(loop, left, right, tile, row, col, speed)
	local speed = vim.deepcopy(speed)
	if tile == "|" then
		if speed[dir["down"]] == 1 then
			mark_table(loop, left, row, col-1) 
			mark_table(loop, right, row, col+1) 
		else
			mark_table(loop, right, row, col-1) 
			mark_table(loop, left, row, col+1) 
		end
	elseif tile == "-" then
		if speed[dir["left"]] == 1 then
			mark_table(loop, left, row-1, col) 
			mark_table(loop, right, row+1, col) 
		else
			mark_table(loop, right, row-1, col) 
			mark_table(loop, left, row+1, col) 
		end
	elseif tile == "L" then
		if speed[dir["up"]] == 1 then
			mark_table(loop, left, row-1, col+1) 
			mark_table(loop, right, row, col-1) 
			mark_table(loop, right, row+1, col) 
			mark_table(loop, right, row+1, col-1) 
		else
			mark_table(loop, right, row-1, col+1) 
			mark_table(loop, left, row, col-1) 
			mark_table(loop, left, row+1, col) 
			mark_table(loop, left, row+1, col-1) 
		end
	elseif tile == "J" then
		if speed[dir["left"]] == 1 then
			mark_table(loop, left, row-1, col-1) 
			mark_table(loop, right, row, col+1) 
			mark_table(loop, right, row+1, col) 
			mark_table(loop, right, row+1, col+1) 
		else
			mark_table(loop, right, row-1, col-1) 
			mark_table(loop, left, row, col+1) 
			mark_table(loop, left, row+1, col) 
			mark_table(loop, left, row+1, col+1) 
		end
	elseif tile == "7" then
		if speed[dir["down"]] == 1 then
			mark_table(loop, right, row-1, col+1) 
			mark_table(loop, right, row-1, col) 
			mark_table(loop, right, row, col+1) 
			mark_table(loop, left, row+1, col-1) 
		else
			mark_table(loop, left, row-1, col+1) 
			mark_table(loop, left, row-1, col) 
			mark_table(loop, left, row, col+1) 
			mark_table(loop, right, row+1, col-1) 
		end
	elseif tile == "F" then
		if speed[dir["down"]] == 1 then
			mark_table(loop, left, row-1, col-1) 
			mark_table(loop, left, row-1, col) 
			mark_table(loop, left, row, col-1) 
			mark_table(loop, right, row+1, col+1) 
		else
			mark_table(loop, right, row-1, col-1) 
			mark_table(loop, right, row-1, col) 
			mark_table(loop, right, row, col-1) 
			mark_table(loop, left, row+1, col+1) 
		end
	else
		assert(false)
	end
end

@local_variables+=
local reg_left = {}
local reg_right = {}

@mark_left_right+=
mark(reg_loop, reg_left, reg_right, tile, prow, pcol, speed)

@define_functions+=
function draw_region(region)
	local min_r, max_r
	local min_c, max_c

	if vim.tbl_count(region) == 0 then
		print(".")
		return
	end

	for r,tbl in pairs(region) do
		if not min_r or min_r > r then
			min_r = r
		end
		if not max_r or max_r < r then
			max_r = r
		end
		for c,_ in pairs(tbl) do
			if not min_c or min_c > c then
				min_c = c
			end
			if not max_c or max_c < c then
				max_c = c
			end
		end
	end

	for r=min_r, max_r do
		local row = ""
		for c=min_c, max_c do
			if region[r] and region[r][c] then
				if type(region[r][c]) == "string" then
					row = row .. region[r][c]
				else
					row = row .. "x"
				end
			else
				row = row .. "."
			end
		end
		print(row)
	end

	@print_infos_region
end

@define_functions+=
function get_area(region)
	local area = 0
	for r,tbl in pairs(region) do
		for c,_ in pairs(tbl) do
			area = area + 1
		end
	end
	return area
end

@decide_which_is_outside+=
local area_left = get_area(reg_left)
local area_right = get_area(reg_right)
local inside
if area_left < area_right then
	inside = reg_left
else
	inside = reg_right
end

@define_functions+=
function expand(loop, reg, r,c)
	if not reg[r] or not reg[r][c] then
		if not loop[r] or not loop[r][c] then
			reg[r] = reg[r] or {}
			reg[r][c] = true
			return true
		end
	end
	return false
end

@expand_inside_region+=
while true do
	local done = true
	for r, tbl in pairs(inside) do
		for c, _ in pairs(tbl) do
			if expand(reg_loop, inside, r-1,c) then done = false end
			if expand(reg_loop, inside, r+1,c) then done = false end
			if expand(reg_loop, inside, r,c-1) then done = false end
			if expand(reg_loop, inside, r,c+1) then done = false end
		end
	end
	if done then
		break
	end
end

@local_variables+=
local reg_loop = {}

@mark_loop+=
reg_loop[prow] = reg_loop[prow] or {}
reg_loop[prow][pcol] = tile

@find_area_of_inside+=
answer = get_area(inside)

