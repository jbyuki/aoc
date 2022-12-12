@*=
@variables
@functions
@parts
@execute

@parts+=
function part1()
	@local_variables
	@read_lines
	@parse_terrain
	@search_best_path_with_dp
	@find_min_path_at_end
	@show_answer
end

@read_lines+=
local lines = {}
for line in io.lines("input.txt") do
  table.insert(lines, line)
end

@parse_terrain+=
local grid = {}
local N = #lines
local M = #lines[1]
for i=1,N do
	for j=1,M do
		local c = lines[i]:sub(j,j)
		local elev
		@if_start_save
		@if_end_save
		@otherwise_just_read_elevation
		@save_elevation
	end
end

@local_variables+=
local start

@if_start_save+=
if c == 'S' then
	start = {i,j}
	elev = 1

@variables+=
local finish

@if_end_save+=
elseif c == 'E' then
	finish = {i,j}
	elev = 26

@otherwise_just_read_elevation+=
else
	elev = c:byte() - ('a'):byte() + 1
end

@save_elevation+=
grid[i] = grid[i] or {}
grid[i][j] = elev

@search_best_path_with_dp+=
local open = { start }
local minpath = { }
minpath[start[1]] = {}
minpath[start[1]][start[2]] = 0

while #open > 0 do
	@pick_next_in_open
	@add_neighbours_if_less_or_nonexistent
end

@pick_next_in_open+=
local pos = open[#open]
local i,j = unpack(pos)
table.remove(open)

@add_neighbours_if_less_or_nonexistent+=
@get_current_height
for di=-1,2,1 do
	for dj=-1,2,1 do
		if math.abs(di)+math.abs(dj) == 1 then
			@check_if_not_out_of_bounds
				@check_if_height_is_ok
					@check_if_min_path_is_nonexistent_or_more
						@add_if_all_conditions_are_met
					end
				end
			end
		end
	end
end

@check_if_not_out_of_bounds+=
if di+i >= 1 and di+i <= N and dj+j >= 1 and dj+j <= M then

@get_current_height+=
local curheight = grid[i][j]

@check_if_height_is_ok+=
local neiheight = grid[i+di][j+dj]
if neiheight <= curheight+1 then

@check_if_min_path_is_nonexistent_or_more+=
local cur = minpath[i][j]
if not minpath[i+di] or not minpath[i+di][j+dj] or minpath[i+di][j+dj] > cur+1 then

@add_if_all_conditions_are_met+=
minpath[i+di] = minpath[i+di] or {}
minpath[i+di][j+dj] = cur+1
table.insert(open, { i+di, j+dj })

@find_min_path_at_end+=
local steps
if not minpath[finish[1]] or not minpath[finish[1]][finish[2]] then
	steps = math.huge
else
	steps = minpath[finish[1]][finish[2]]
end


@show_answer+=
print(steps)

@parts+=
function part2()
	@local_variables
	@read_lines
	@parse_terrain
	@list_all_starting_points
	for _, start in ipairs(starts) do
		@search_best_path_with_dp
		@find_min_path_at_end
		@save_best_end
	end
	@show_answer_part2
end

@list_all_starting_points+=
local starts = {}
for i=1,N do
	for j=1,M do
		if grid[i][j] == 1 then
			table.insert(starts, {i,j})
		end
	end
end

@local_variables+=
local best_steps

@save_best_end+=
best_steps = best_steps and math.min(steps, best_steps) or steps

@show_answer_part2+=
print(best_steps)

@execute+=
part2()
