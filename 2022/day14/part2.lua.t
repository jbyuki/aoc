##aoc
@variables+=
local answer_test2 = 93

@parts+=
function part2(lines)
	@local_variables
	@create_terrain
	@simulate_sand_falling_until_stuck
	@show_answer
	return answer
end

@simulate_sand_falling_until_stuck+=
local answer = 0
while true do
	local pos = { 500, 0 }
	@check_that_source_is_free
	while true do
		@if_sand_at_floor_stop
		@advance_sand_below
	end
	answer = answer + 1 
end


@if_sand_at_floor_stop+=
if pos[2] >= bottom+1 then
	grid[pos[1]] = grid[pos[1]] or {}
	grid[pos[1]][pos[2]] = true
	break
end

@check_that_source_is_free+=
if grid[pos[1]] and grid[pos[1]][pos[2]] then
	break
end
