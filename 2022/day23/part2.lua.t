##aoc
@variables+=
local answer_test2 = 20

@parts+=
function part2(lines, istest)
	@local_variables
	@parse_grid
	@init_states
	@simulate_according_to_rules
	return round
end

