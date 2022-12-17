##aoc
@variables+=
local answer_test2 = 1514285714288

@parts+=
function part2(lines, istest)
	@local_variables
	local jet = lines[1]
	@simulate_rock_falling_find_periodicity
	@compute_tower_height_evolved
	return answer
end

@simulate_rock_falling_find_periodicity+=
local rock_idx = 1
while true do
	@choose_pattern
	@rock_fall
	@place_piece
	@encode_tower_top
	@break_if_enough_rocks_evolved
end

@functions+=
function encode_row(row)
	local num = 0
	for i=2,8 do
		num = num * 2
		if row[i] then
			num = num + 1
		end
	end
	return num
end

@local_variables+=
local memoize = {}

@rock_fall-=
local start_jet = (jet_idx-1)%#jet+1

@local_variables+=
local tower_extra = 0

@encode_tower_top+=
local encoded = ""
local previous_row = 0

for i=#tower,1,-1 do
	local num = encode_row(tower[i])
	encoded = encoded .. string.char(num)
	if bit.bor(num, previous_row) == 127 then
		break
	end
	previous_row = num
end

memoize[encoded] = memoize[encoded] or {}
memoize[encoded][pat_idx] = memoize[encoded][pat_idx] or {}

if memoize[encoded][pat_idx][start_jet] then
	local previous_tower, previous_rock_idx = unpack(memoize[encoded][pat_idx][start_jet])
	local delta = rock_idx - previous_rock_idx
	local rep = math.floor((evolved_limit - (rock_idx+1))/delta)
	if rep > 0 then

		rock_idx = rock_idx + rep*delta
		tower_extra = tower_extra + rep*(#tower - previous_tower)
	end
end

memoize[encoded][pat_idx][start_jet] = { #tower, rock_idx }


@variables+=
local evolved_limit = 1000000000000+1

@compute_tower_height_evolved+=
local answer = #tower + tower_extra

@break_if_enough_rocks_evolved+=
rock_idx = rock_idx + 1
if rock_idx == evolved_limit then
	-- @draw_tower
	break
end
