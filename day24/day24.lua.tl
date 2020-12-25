@*=
@functions
@read_input
--@read_test
@solve_part_1
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
local all = {}
for _, line in ipairs(lines) do
	local inst = {}
	@read_instructions
	table.insert(all, inst)
end

local flipped = {}
for _, inst in ipairs(all) do
	local pos = { x = 0, y = 0 }
	@step_through_instruction
	flipped[pos.x] = flipped[pos.x] or {}
	flipped[pos.x][pos.y] = flipped[pos.x][pos.y] or 0
	@flip_tile
end

@count_all_black+=
local black = 0
for _, row in pairs(flipped) do
	for _, state in pairs(row) do
		@count_black
	end
end
print(black)

@read_instructions+=
local i = 1
while i <= string.len(line) do
	local c = string.sub(line, i, i)
	if c == "e" or c == "w" then
		table.insert(inst, c)
		i = i+1
	elseif c == "s" or c == "n" then
		table.insert(inst, string.sub(line, i, i+1))
		i = i+2
	end
end

@step_through_instruction+=
for _, s in ipairs(inst) do
	if s == "e" then
		pos.x = pos.x + 1
	elseif s == "w" then
		pos.x = pos.x - 1
	elseif s == "nw" then
		pos.y = pos.y + 1
		pos.x = pos.x - 1
	elseif s == "ne" then
		pos.y = pos.y + 1
	elseif s == "sw" then
		pos.y = pos.y - 1
	elseif s == "se" then
		pos.y = pos.y - 1
		pos.x = pos.x + 1
	else
		assert(false, "Unknown direction " .. s)
	end
end

@flip_tile+=
if flipped[pos.x][pos.y] == 1 then
	flipped[pos.x][pos.y] = nil
else
	flipped[pos.x][pos.y] = 1
end

@count_black+=
if state == 1 then
	black = black + 1
end

@solve_part_2+=
for day=1,100 do
	local black = {}
	for x,row in pairs(flipped) do
		for y, state in pairs(row) do
			@accumulate_black
		end
	end

	local next_state = {}

	for x,row in pairs(flipped) do
		for y, state in pairs(row) do
			@if_black_and_more_than_two_flip
		end
	end

	for x,row in pairs(black) do
		for y, state in pairs(row) do
			@if_white_and_more_than_two_flip
		end
	end

	flipped = next_state

end

@count_all_black

@functions+=
function incAt(tab, x, y)
	tab[x] = tab[x] or {}
	tab[x][y] = tab[x][y] or 0
	tab[x][y] = tab[x][y] + 1
end

@accumulate_black+=
incAt(black, x-1, y)
incAt(black, x+1, y)
incAt(black, x-1, y+1)
incAt(black, x, y+1)
incAt(black, x+1, y-1)
incAt(black, x, y-1)

@functions+=
function getAt(tab, x, y)
	tab[x] = tab[x] or {}
	return tab[x][y] or 0
end

@functions+=
function setAt(tab, x, y, v)
	tab[x] = tab[x] or {}
	tab[x][y] = v
end

@if_black_and_more_than_two_flip+=
local b = getAt(flipped, x, y)
local n = getAt(black, x, y)
if b == 1 then
	if n == 0 or n > 2 then
	else
		setAt(next_state, x, y, 1)
	end
end

@if_white_and_more_than_two_flip+=
local b = getAt(flipped, x, y)
local n = getAt(black, x, y)
if b == 0 and n == 2 then
	setAt(next_state, x, y, 1)
end
