##aoc
@variables+=
-- local test_input2 = [[
-- ]]

@variables+=
local answer_test2 = 2

@parts+=
@define_functions
function part2(lines, istest)
	@local_variables
	@foreach_line_find_previous_prediction
	return answer
end


@foreach_line_find_previous_prediction+=
answer = 0
for _, line in ipairs(lines) do
	@parse_line
	@find_last_increment
	@add_up_to_find_previous_prediction
	@add_prediction_to_answer
end

@add_up_to_find_previous_prediction+=
local prediction = 0
for i=#history,1,-1 do
	local seq = history[i]
	prediction = seq[1] - prediction
end

