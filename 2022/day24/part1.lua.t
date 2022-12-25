##aoc
@variables+=
local test_input = [[
  #.######
  #>>.<^<#
  #.<..<<#
  #>v.><>#
  #<^v^^>#
  ######.#
]]

local answer_test1 = 18

@parts+=
function part1(lines, istest)
	@local_variables
	@parse_input
	@find_grid_size
	@init_states
	@do_bfs
	return answer
end

@parse_input+=
local grid = {}
for _, line in ipairs(lines) do
	local row = vim.trim(line)
	table.insert(grid, vim.split(row, ""))
end

@do_bfs+=
local minute = 1
while true do
	@blizzard_position_for_this_round
	-- @draw_blizzard_map
	@move_to_all_possible_squares
	@check_if_one_reached_goal
	minute = minute + 1
end

@find_grid_size+=
local N = #grid
local M = #grid[1]

@blizzard_position_for_this_round+=
local blizzards = {}
for i=2,N-1 do
	for j=2,M-1 do
		if grid[i][j] ~= "." then
			@move_left_blizzards
			@move_right_blizzards
			@move_up_blizzards
			@move_down_blizzards
		end
	end
end

@move_left_blizzards+=
if grid[i][j] == "<" then
	local nj = (j - 2 - minute)%(M-2) + 2
	blizzards[i] = blizzards[i] or {}
	blizzards[i][nj] = true

@move_right_blizzards+=
elseif grid[i][j] == ">" then
	local nj = (j - 2 + minute)%(M-2) + 2
	blizzards[i] = blizzards[i] or {}
	blizzards[i][nj] = true

@move_up_blizzards+=
elseif grid[i][j] == "^" then
	local ni = (i - 2 - minute)%(N-2) + 2
	blizzards[ni] = blizzards[ni] or {}
	blizzards[ni][j] = true

@move_down_blizzards+=
elseif grid[i][j] == "v" then
	local ni = (i - 2 + minute)%(N-2) + 2
	blizzards[ni] = blizzards[ni] or {}
	blizzards[ni][j] = true
end

@do_bfs-=
local pos = { 1, 2 }
local open = { pos }

@move_to_all_possible_squares+=
local next_open = {}
local close = {}
for k=1,#open do
	local i, j = unpack(open[k])
	@add_free_neighbouring
end
open = next_open

@init_states+=
local walls = {}
for i=1,N do
	for j=1,M do
		if i == 1 or j == 1 or i == N or j == M then
			if i == 1 and j == 2 then
				walls[i-1] = walls[i-1] or {}
				walls[i-1][j] = true
			elseif i == N and j == M-1 then
				walls[i+1] = walls[i+1] or {}
				walls[i+1][j] = true
			else
				walls[i] = walls[i] or {}
				walls[i][j] = true
			end
		end
	end
end

@add_free_neighbouring+=
for di=-1,1 do
	for dj=-1,1 do
		if math.abs(di)+math.abs(dj) <= 1 then
			if (not blizzards[i+di] or not blizzards[i+di][j+dj]) and (not walls[i+di] or not walls[i+di][j+dj]) then
				if not close[i+di] or not close[i+di][j+dj] then
					close[i+di] = close[i+di] or {}
					close[i+di][j+dj] = true
					table.insert(next_open, {i+di, j+dj})
				end
			end
		end
	end
end

@local_variables+=
local answer

@check_if_one_reached_goal+=
if close[N] and close[N][M-1] then
	answer = minute
	break
end

@draw_blizzard_map+=
print("--")
for bi=2,N-1 do
	local row = {}
	for bj=2,M-1 do
		if blizzards[bi] and blizzards[bi][bj] then
			table.insert(row, "@")
		else
			table.insert(row, ".")
		end
	end
	print(table.concat(row))
end
