@*=
@functions
@read_input
--@read_test
-- @solve_part_1
@solve_part_2
@display_result

@read_input+=
local lines = {}

for line in io.lines("input.txt") do
	table.insert(lines, line)
end

@read_test+=
local lines = {}

for line in io.lines("test.txt") do
	table.insert(lines, line)
end

@solve_part_1+=
local i = 2
local cards = {}
@read_player_cards
local p1 = cards
i = i+2
cards = {}
@read_player_cards
local p2 = cards

while #p1 > 0 and #p2 > 0 do
	@draw_cards_from_top
	@put_cards_in_winners_deck
end

local score = 0
if #p1 > 0 then
	local cards = p1
	@compute_score_final
else
	local cards = p2
	@compute_score_final
end

@read_player_cards+=
while i <= #lines and lines[i] ~= "" do
	table.insert(cards, tonumber(lines[i]))
	i = i + 1
end


@draw_cards_from_top+=
local p1c = p1[1]
local p2c = p2[1]
table.remove(p1, 1)
table.remove(p2, 1)

@put_cards_in_winners_deck+=
if p1c > p2c then
	table.insert(p1, p1c)
	table.insert(p1, p2c)
else
	table.insert(p2, p2c)
	table.insert(p2, p1c)
end

@compute_score_final+=
for i,card in ipairs(cards) do
	score = score + (#cards-i+1)*card
end

@display_result+=
print(score)

@solve_part_2+=
local i = 2
local cards = {}
@read_player_cards
local p1 = cards
i = i+2
cards = {}
@read_player_cards
local p2 = cards

play_game(p1, p2)

local score = 0
if #p1 > 0 then
	local cards = p1
	@compute_score_final
else
	local cards = p2
	@compute_score_final
end

@functions+=
function play_game(p1, p2)
	local saved = {}
	while #p1 > 0 and #p2 > 0 do
		@check_if_current_game_is_not_played
		@save_current_game_state
		@draw_top_from_each_game
		@if_both_have_enough_play_subgame
		@otherwise_check_which_is_higher
		
		@place_cards_in_winners_hand
	end
	@check_who_is_winner
end

@functions-=
function list_equal(a, b)
	if #a == #b then
		for i=1,#a do
			if a[i] ~= b[i] then
				return false
			end
		end
		return true
	end
	return false
end

@check_if_current_game_is_not_played+=
for _, s in ipairs(saved) do
	if list_equal(s[1], p1) and list_equal(s[2], p2) then
		return 1
	end
end

@save_current_game_state+=
table.insert(saved, { vim.deepcopy(p1), vim.deepcopy(p2) })

@draw_top_from_each_game+=
local p1c = p1[1]
local p2c = p2[1]
table.remove(p1, 1)
table.remove(p2, 1)

@functions-=
function list_sub(a, s1, s2)
	local r = {}
	for i=s1,s2 do
		table.insert(r, a[i])
	end
	return r
end

@if_both_have_enough_play_subgame+=
if p1c <= #p1 and p2c <= #p2 then
	local subp1 = list_sub(p1, 1, p1c)
	local subp2 = list_sub(p2, 1, p2c)
	win = play_game(subp1, subp2)

@otherwise_check_which_is_higher+=
else
	if p1c > p2c then win = 1
	else win = 2 end
end


@place_cards_in_winners_hand+=
if win == 1 then
	table.insert(p1, p1c)
	table.insert(p1, p2c)
else 
	table.insert(p2, p2c)
	table.insert(p2, p1c)
end

@check_who_is_winner+=
if #p1 > 0 then return 1
else return 2 end
