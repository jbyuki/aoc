@*=
@variables
@functions
@parts
@execute

@parts+=
function part1()
	@read_lines_from_file
	@create_visibility_map
	@visible_rowise
	@visible_columnwise
	@sum_visible_map
	@show_answer
end

@read_lines_from_file+=
local lines = {}
for line in io.lines("input.txt") do
  table.insert(lines, line)
end

@visible_rowise+=
@look_from_left
@look_from_right

@create_visibility_map+=
local visible = {}
for i=1,#lines do
	local row = {}
	for j=1,#lines[1] do
		table.insert(row, 0)
	end
	table.insert(visible, row)
end

@look_from_left+=
for i=1,#lines do
	visible[i][1] = 1
	local max_height = tonumber(lines[i]:sub(1,1))
	for j=2,N do
		@update_visible_map
	end
end

@create_visibility_map+=
local N = #lines[1]

@look_from_right+=
for i=1,#lines do
	visible[i][N] = 1
	local max_height = tonumber(lines[i]:sub(N,N))
	for j=N,2,-1 do
		@update_visible_map
	end
end

@visible_columnwise+=
@look_down
@look_up

@look_down+=
for j=1,N do
	visible[1][j] = 1
	local max_height = tonumber(lines[1]:sub(j,j))
	for i=2,#lines do
		@update_visible_map
	end
end

@update_visible_map+=
local height = tonumber(lines[i]:sub(j,j))
if height > max_height then
	visible[i][j] = 1
	max_height = height
end

@create_visibility_map+=
local M = #lines

@look_up+=
for j=1,N do
	visible[M][j] = 1
	local max_height = tonumber(lines[M]:sub(j,j))
	for i=M,2,-1 do
		@update_visible_map
	end
end

@sum_visible_map+=
local total = 0
for i=1,M do
	for j=1,N do
		total = total + visible[i][j]
	end
end

@show_answer+=
print(total)

@parts+=
function part2()
	@read_lines_from_file
	@create_visibility_map
	@foreach_cell_find_max_scenic_score
	@show_answer
end

@foreach_cell_find_max_scenic_score+=
for i=1,M do
	for j=1,N do
		@find_scenic_score
		@compare_if_best_scenic_score
	end
end

@variables+=
local total = 0

@find_scenic_score+=
@get_current_height
@find_distance_top
@find_distance_bot
@find_distance_right
@find_distance_left
@compute_scenic_score

@get_current_height+=
local cur = tonumber(lines[i]:sub(j,j))

@find_distance_top+=
local top = 0
local ii = i-1
while ii >= 1 do
	local look = tonumber(lines[ii]:sub(j,j))
	top = top + 1
	@stop_if_higher
	ii = ii - 1
end

@stop_if_higher+=
if look >= cur then
	break
end

@find_distance_bot+=
local bot = 0
local ii = i+1
while ii <= M do
	local look = tonumber(lines[ii]:sub(j,j))
	bot = bot + 1
	@stop_if_higher
	ii = ii + 1
end

@find_distance_left+=
local left = 0
local jj = j-1
while jj >= 1 do
	local look = tonumber(lines[i]:sub(jj,jj))
	left = left + 1
	@stop_if_higher
	jj = jj - 1
end

@find_distance_right+=
local right = 0
local jj = j+1
while jj <= N do
	local look = tonumber(lines[i]:sub(jj,jj))
	right = right + 1
	@stop_if_higher
	jj = jj + 1
end

@compute_scenic_score+=
local score = top * bot * right * left

@compare_if_best_scenic_score+=
if score > total then
	total = score
end

@execute+=
part2()
