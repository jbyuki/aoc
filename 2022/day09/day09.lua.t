@*=
@variables
@functions
@parts
@execute

@parts+=
function part1()
	@part1_variables
	@read_lines
	@create_visited_grid
	@simulate_each_commands
	@count_visited_grid
	@show_answer
end

@read_lines+=
local lines = {}
for line in io.lines("input.txt") do
  table.insert(lines, line)
end

@variables+=
local visited = {}

@create_visited_grid+=
visited[0] = {}
visited[0][0] = true


@simulate_each_commands+=
for _, line in ipairs(lines) do
	@parse_command
	@execute_command
end

@parse_command+=
local	dir, count = unpack(vim.split(line, " "))
count = tonumber(count)

@execute_command+=
@transform_dir_to_vector

for i=1,count do
	@move_head
	@follow_tail
	@mark_tail_visited
end

@transform_dir_to_vector+=
local dir_dict = {
	R = {1, 0},
	L = {-1, 0},
	U = {0, 1},
	D = {0, -1},
}

local inc = dir_dict[dir]

@part1_variables+=
local tailpos = {0, 0}
local headpos = {0, 0}

@move_head+=
headpos[1] = headpos[1] + inc[1]
headpos[2] = headpos[2] + inc[2]

@follow_tail+=
@follow_tail_same_column
@follow_tail_same_row
@follow_tail_diagonal

@functions+=
function copysign(num, ref)
	if ref < 0 then return -num
	else return num end
end

@follow_tail_same_column+=
if headpos[2] == tailpos[2] and math.abs(headpos[1] - tailpos[1]) > 1 then
	tailpos[1] = tailpos[1] + copysign(1, headpos[1] - tailpos[1])
	
@follow_tail_same_row+=
elseif headpos[1] == tailpos[1] and math.abs(headpos[2] - tailpos[2]) > 1 then
	tailpos[2] = tailpos[2] + copysign(1, headpos[2] - tailpos[2])

@follow_tail_diagonal+=
elseif math.abs(headpos[1] - tailpos[1]) + math.abs(headpos[2] - tailpos[2]) > 2 then
	tailpos[1] = tailpos[1] + copysign(1, headpos[1] - tailpos[1])
	tailpos[2] = tailpos[2] + copysign(1, headpos[2] - tailpos[2])
end

@mark_tail_visited+=
visited[tailpos[1]] = visited[tailpos[1]] or {}
visited[tailpos[1]][tailpos[2]] = true

@variables+=
local total = 0

@count_visited_grid+=
for _, row in pairs(visited) do
	total = total + vim.tbl_count(row)
end

@show_answer+=
print(total)

@parts+=
function part2()
	@part2_variables
	@read_lines
	@create_visited_grid
	@simulate_each_commands_10_knots
	@count_visited_grid
	@show_answer
end

@simulate_each_commands_10_knots+=
for _, line in ipairs(lines) do
	@parse_command
	@execute_command_10_tail
end

@execute_command_10_tail+=
@transform_dir_to_vector

for i=1,count do
	@move_head
	@follow_tail_10_knots
	@mark_tail_visited
end

@functions+=
function follow(headpos, tailpos)
	@follow_tail
end

@part2_variables+=
local ropepos = {}
for i=1,10 do
	table.insert(ropepos, {0,0})
end

-- aliases
local headpos = ropepos[1]
local tailpos = ropepos[10]

@follow_tail_10_knots+=
for j=1,9 do
	follow(ropepos[j], ropepos[j+1])
end

@execute+=
part2()
