##aoc
@variables+=
local test_input = [[
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
]]

local answer_test1 = 13

@parts+=
function part1(lines, istest)
	@local_variables
	@process_each_card_part1
	return answer
end

@process_each_card_part1+=
for _, card in ipairs(lines) do
	@get_winning_numbers
	@count_numbers_you_have_winning
	@add_power_of_two
end

@get_winning_numbers+=
local s, _ = card:find(":")
local rest = card:sub(s+1)
local groups = vim.split(rest, "|")
local winning = vim.split(groups[1], "%s+", {trimempty=true})
local win_set = {}
for _, num in ipairs(winning) do
	win_set[num] = true
end

@count_numbers_you_have_winning+=
local mine = vim.split(groups[2], "%s+", {trimempty=true})
local count = 0
for _, num in ipairs(mine) do
	if win_set[num] then
		count = count + 1
	end
end

@local_variables+=
local answer = 0

@add_power_of_two+=
if count > 0 then
	answer = answer + 2 ^ (count-1)
end

