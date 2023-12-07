##aoc
@variables+=
local test_input = [[
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
]]

local answer_test1 = 6440

@parts+=
@define_functions
function part1(lines, istest)
	@local_variables
	@parse_cards
	@foreach_card_save_type
	@sort_by_type
	@compute_final_score
	return answer
end

@local_variables+=
local cards = {}
local scores = {}

@parse_cards+=
for _, line in ipairs(lines) do
	local card, score = unpack(vim.split(line, "%s+", {trimempty=true}))
	table.insert(cards, card)
	table.insert(scores, tonumber(score))
end

@foreach_card_save_type+=
for i=1,#cards do
	@count_cards_in_hand
	@from_counts_determine_type
	@save_type
end

@count_cards_in_hand+=
local saved = {}
for j=1,5 do
	local c = cards[i]:sub(j,j)
	if not saved[c] then
		saved[c] = 0
	end
	saved[c] = saved[c] + 1
end

@from_counts_determine_type+=
local counts = vim.tbl_values(saved)
table.sort(counts, function(a,b) return a > b end)

local type
if counts[1] == 5 then
	type = 0
elseif counts[1] == 4 then
	type = 1
elseif counts[1] == 3 and counts[2] == 2 then -- FULL HOUSE
	type = 2
elseif counts[1] == 3 then
	type = 3
elseif counts[1] == 2 and counts[2] == 2 then
	type = 4
elseif counts[1] == 2 then
	type = 5
else
	type = 6
end

@local_variables+=
local types = {}

@save_type+=
table.insert(types, type)

@local_variables+=
local order = {
	T = 10,
	J = 11,
	Q = 12,
	K = 13,
	A = 14,
}

for i=2,9 do
	order[tostring(i)] = i
end

@sort_by_type+=
local index = {}
for i=1,#cards do
	table.insert(index, i)
end

table.sort(index, function(i,j) 
	if types[i] < types[j] then
		return true
	elseif types[i] > types[j] then
		return false
	else
		for k=1,5 do
			local oi = order[cards[i]:sub(k,k)]
			local oj = order[cards[j]:sub(k,k)]

			if oi ~= oj then
				return oi > oj
			end
		end
		return false
	end
end)

local rank = {}
for r,i in ipairs(index) do
	rank[i] = #cards - r + 1
end

@compute_final_score+=
local answer = 0
for i=1,#scores do
	answer = answer + scores[i]*rank[i]
end

