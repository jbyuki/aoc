##aoc
@variables+=
local answer_test2 = 1707

@parts+=
function part2(lines, istest)
	@local_variables
	@parse_input
	@calculate_distance_from_one_to_another
	@get_non_zero
	@compute_total_possible_flow
	@do_dp_with_elephant
	return answer
end

@do_dp_with_elephant+=

