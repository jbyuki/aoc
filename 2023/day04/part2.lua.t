##aoc
@variables+=
local answer_test2 = 30

@parts+=
function part2(lines, istest)
	@local_variables
	@initialize_num_cards
	for i, card in ipairs(lines) do
		@get_winning_numbers
		@count_numbers_you_have_winning
		@add_to_subsequent
	end
	@sum_up_counts
	return answer
end

@initialize_num_cards+=
local counts = {}
for i=1,#lines do
	counts[i] = 1
end

@add_to_subsequent+=
for j=i+1,math.min(#lines, i+count) do
	counts[j] = counts[j] + counts[i]
end

@sum_up_counts+=
for _, c in ipairs(counts) do
	answer = answer + c
end

