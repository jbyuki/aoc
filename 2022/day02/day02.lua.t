@*=
@variables
@parts

@execute

@parts+=
function part1()
	@read_input
	@print_score
end

@read_input+=
for line in io.lines("input.txt") do
	local elf = tonum[line:sub(1,1)]
	local you = tonum[line:sub(3,3)]

	@compute_score_shape
	@compute_score_win
	@add_score
end

@variables+=
local tonum = { X = 1, Y = 2, Z = 3, A = 1, B = 2, C = 3 }

@compute_score_shape+=
local score = you

@compute_score_win+=
local match_score = {
--  r  p  s (you)
	{ 3, 6, 0},  -- r
	{ 0, 3, 6},  -- p
	{	6, 0, 3}  -- s
}

score = score + match_score[elf][you]

@read_input-=
local total_score = 0

@add_score+=
total_score = total_score + score

@print_score+=
print(total_score)

@parts+=
function part2()
	@read_input_part2
	@print_score
end

@read_input_part2+=
for line in io.lines("input.txt") do
	local elf = tonum[line:sub(1,1)]
	local choice = tonum[line:sub(3,3)]

	@decide_which_shape
	@compute_score_shape
	@compute_score_win
	@add_score
end

@decide_which_shape+=
local you
if choice == 1 then -- need to lose
	local lose = { 3, 1, 2 }
	you = lose[elf]
elseif choice == 2 then -- need draw
	local draw = { 1, 2, 3 }
	you = draw[elf]
elseif choice == 3 then -- need to win
	local win = { 2, 3, 1 }
	you = win[elf]
end

@read_input_part2-=
local total_score = 0

@execute+=
part2()
