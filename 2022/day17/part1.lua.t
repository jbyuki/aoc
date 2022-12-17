##aoc
@variables+=
local test_input = [[
>>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
]]
local answer_test1 = 3068

@parts+=
function part1(lines, istest)
	@local_variables
	local jet = lines[1]
	@simulate_rock_falling
	@compute_tower_height
	return answer
end

@simulate_rock_falling+=
local rock_idx = 1
while true do
	@choose_pattern
	@rock_fall
	@place_piece
	@break_if_enough_rocks
end

@local_variables+=
local patterns = {
	{ 
		{ 1, 1, 1, 1 } 
	},
	{ 
		{ 0, 1, 0 },
		{ 1, 1, 1 },
		{ 0, 1, 0 },
	},
	{
		{ 0, 0, 1 },
		{ 0, 0, 1 },
		{ 1, 1, 1 },
	},
	{
		{ 1 },
		{ 1 },
		{ 1 },
		{ 1 },
	},
	{
		{ 1, 1 },
		{ 1, 1 },
	},
}

@local_variables+=
local tower = {}

@choose_pattern+=
local pat_idx = (rock_idx-1)%#patterns + 1
P = patterns[pat_idx]
local posx = 3
local posy = #tower+3+#P

@local_variables+=
local jet_idx = 1

@functions+=
function collide(piece, tower, posx, posy)
	for y=1,#piece do
		for x=1,#piece[y] do
			if piece[y][x] == 1 then
				@check_if_collide_with_tower
			end
		end
	end
	return false
end

@check_if_collide_with_tower+=
local px = x+posx
local py = posy-(y-1)

if px <= 1 then
	return true
end

if px >= 9 then
	return true
end

if py <= 0 then
	return true
end

if tower[py] and tower[py][px] then
	return true
end

@rock_fall+=
while true do
	@make_piece_go_sidewas
	@make_piece_go_down_break_if_rest
end

@make_piece_go_sidewas+=
local j = (jet_idx-1)%#jet+1
jet_idx = jet_idx + 1
local cmd = jet:sub(j,j)
if cmd == "<" then
	if not collide(P, tower, posx-1, posy) then
		posx = posx - 1
	end
elseif cmd == ">" then
	if not collide(P, tower, posx+1, posy) then
		posx = posx + 1
	end
end

@make_piece_go_down_break_if_rest+=
if collide(P, tower, posx, posy-1) then
	break
end

posy = posy - 1

@place_piece+=
for y=1,#P do
	for x=1,#P[y] do
		if P[y][x] == 1 then
			@place_piece_in_tower
		end
	end
end

@place_piece_in_tower+=
local px = x+posx
local py = posy-(y-1)

tower[py] = tower[py] or {}
tower[py][px] = true

@break_if_enough_rocks+=
rock_idx = rock_idx + 1
if rock_idx == 2023 then
	-- @draw_tower
	break
end

@compute_tower_height+=
local answer = #tower

@draw_tower+=
for i=#tower,1,-1 do
	local row = {}
	for j=2,8 do
		if tower[i][j] then
			table.insert(row, "#")
		else
			table.insert(row, ".")
		end
	end
	print(table.concat(row, ""))
end

