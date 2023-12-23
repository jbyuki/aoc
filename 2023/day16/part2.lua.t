##aoc
@variables+=
-- local test_input2 = [[
-- ]]

@variables+=
local answer_test2 = 51

@parts+=
@define_functions
function part2(lines, istest)
	@local_variables

	local find_energized = function(initial_dir, initial_pos)
		passed = {}
		local open = {{dir = initial_dir, pos = initial_pos}}
		@do_bfs_with_beam
		return vim.tbl_count(passed)
	end

	local initial = {}
	@fill_initial_left
	@fill_initial_right
	@fill_initial_up
	@fill_initial_down
	
	local answer = 0
	for _, d in ipairs(initial) do
		answer = math.max(answer, find_energized(d[1], d[2]))
	end
	return answer
end

@fill_initial_left+=
for i=1,#lines do
	table.insert(initial, {{0,1}, {i,1}})
end

@fill_initial_right+=
for i=1,#lines do
	table.insert(initial, {{0,-1}, {i,#lines[1]}})
end

@fill_initial_up+=
for i=1,#lines[1] do
	table.insert(initial, {{1,0}, {1,i}})
end

@fill_initial_down+=
for i=1,#lines[1] do
	table.insert(initial, {{-1,0}, {#lines,i}})
end

