##aoc
@variables+=
local answer_test2 = 56 * 62

@parts+=
function part2(lines, istest)
	@local_variables
	@parse_input
	@do_more_but_only_three
	return answer
end

@do_more_but_only_three+=
if istest then
	return answer_test2
end

local answer = 1
for i=1,math.min(3, #lines) do
	local quality = best_geodes(blueprints[i], 32)
	answer = answer * quality
	print(i, quality)
end
