##aoc
@variables+=
local answer_test2 = 1623178306

@parts+=
function part2(lines, istest)
	@local_variables
	@read_sequence
	@multisequence_by_key
	@initialise
	for K=1,10 do
		@move_numbers_in_sequence
	end
	@find_grove_coordinates
	return answer
end

@multisequence_by_key+=
for i=1,#seq do
	seq[i] = seq[i] * 811589153
end
