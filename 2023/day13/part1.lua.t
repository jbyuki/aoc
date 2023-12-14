##aoc
@variables+=
local test_input1 = [[
	#.##..##.
	..#.##.#.
	##......#
	##......#
	..#.##.#.
	..##..##.
	#.#.##.#.
	
	#...##..#
	#....#..#
	..##..###
	#####.##.
	#####.##.
	..##..###
	#....#..#
]]

local answer_test1 = 405

@parts+=
@define_functions
function part1(lines, istest)
	local answer = 0
	@local_variables
	@split_patterns
	@foreach_pattern_find_reflection
	return answer
end

@split_patterns+=
local patterns = {}

local cur_pattern = {}
for _, line in ipairs(lines) do
	if vim.trim(line) == "" then
		table.insert(patterns, cur_pattern)
		cur_pattern = {}
	else
		table.insert(cur_pattern, vim.trim(line))
	end
end

if #cur_pattern > 0 then
	table.insert(patterns, cur_pattern)
end

@foreach_pattern_find_reflection+=
for k, pattern in ipairs(patterns) do
	local found = false
	@find_vertical_reflection_line
	@find_horizontal_reflection_line
	assert(found)
end

@find_vertical_reflection_line+=
if not found then
	local vert_line
	@find_vertical_line

	if vert_line then
		answer = answer + vert_line 
		found = true
	end
end

@find_horizontal_reflection_line+=
if not found then
	local vert_line
	@transpose_pattern

	@find_vertical_line
	if vert_line then
		answer = answer + 100*vert_line 
		found = true
	end
end

@find_vertical_line+=
for col=1,#pattern[1]-1 do
	local mirror = true
	for _, line in ipairs(pattern) do
		@check_if_line_is_at_line
	end
	if mirror then
		vert_line = col
		break
	end
end

@check_if_line_is_at_line+=
local i=0
while col-i >= 1 and i+col+1 <= #line do
	if line:sub(col-i,col-i) ~= line:sub(col+i+1,col+i+1) then
		mirror = false
		break
	end
	i = i + 1
end

@transpose_pattern+=
local transposed = {}
for i=1,#pattern[1] do
	local row = ""
	for _, line in ipairs(pattern) do
		row = row .. line:sub(i,i)
	end
	table.insert(transposed, row)
end
pattern = transposed

