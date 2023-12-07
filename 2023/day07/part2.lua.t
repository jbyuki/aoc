##aoc
@variables+=
local answer_test2 = 5905

@parts+=
@define_functions
function part2(lines, istest)
	@local_variables
	@create_new_order
	@parse_cards
	@foreach_card_save_type_strongest
	@sort_by_type
	@compute_final_score
	return answer
end


@create_new_order+=
order["J"] = 1

@foreach_card_save_type_strongest+=
for i=1,#cards do
	@count_cards_in_hand
	@from_counts_determine_type_strongest
	@save_type
end

@from_counts_determine_type_strongest+=
local count_J = saved["J"] or 0
saved["J"] = 0

local counts = vim.tbl_values(saved)
table.sort(counts, function(a,b) return a > b end)

table.insert(counts, 0)
table.insert(counts, 0)

local type
if counts[1]+count_J == 5 then
	type = 0
elseif counts[1]+count_J == 4 then
	type = 1
elseif (counts[1] == 3 and counts[2] == 2) or (count_J == 1 and counts[1] == 2 and counts[2] == 2) then
	type = 2
elseif counts[1]+count_J == 3 then
	type = 3
elseif (counts[1] == 2 and counts[2] == 2) then
	type = 4
elseif counts[1] == 2 or (count_J == 1 and counts[1] == 1) then
	type = 5
else
	type = 6
end



