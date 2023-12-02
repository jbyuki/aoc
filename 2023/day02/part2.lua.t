##aoc
@variables+=
local answer_test2 = 2286

@parts+=
function part2(lines, istest)
	local answer
	@local_variables
	local answer = 0
	for _, line in ipairs(lines) do
		@get_game_id
		@split_by_set
		@get_minimum_power
		@add_minimum_power
	end
	return answer
end

@get_minimum_power+=
local mred = 0
local mgreen = 0
local mblue = 0
for _, set in ipairs(sets) do
	@parse_set
	@get_minimum_for_each_color
end

@get_minimum_for_each_color+=
if reds and tonumber(reds) > mred then
	mred = tonumber(reds)
end

if greens and tonumber(greens) > mgreen then
	mgreen = tonumber(greens)
end

if blues and tonumber(blues) > mblue then
	mblue = tonumber(blues)
end

@add_minimum_power+=
answer = answer + mblue * mred * mgreen

