##aoc
@variables+=
local test_input = [[
1
2
-3
3
-2
0
4
]]
local answer_test1 = 3

@parts+=
function part1(lines, istest)
	@local_variables
	@read_sequence
	@initialise
	@move_numbers_in_sequence
	@find_grove_coordinates
	return answer
end

@read_sequence+=
local seq = {}
for _, line in ipairs(lines) do
	table.insert(seq, tonumber(line))
end

@initialise+=
@initialise_positions
@initialise_lookup

@initialise_positions+=
local pos = {}
for i=1,#seq do
	table.insert(pos, i)
end

@move_numbers_in_sequence+=
for i=1,#seq do
	local v = seq[i]
	if v > 0 then
		@move_forwards
	elseif v < 0 then
		@move_backwards
	end
end

@initialise_lookup+=
local pos2idx = {}
for i=1,#seq do
	pos2idx[i] = i
end

@move_forwards+=
for m=1,v%(#seq-1) do
	local next_pos = pos[i] + 1

	if next_pos == #seq+1 then
		@warp_to_first
		next_pos = 2
	end

	local k = pos2idx[next_pos]
	pos2idx[pos[i]] = k
	pos2idx[pos[k]] = i
	pos[k], pos[i] = pos[i], pos[k]

	if next_pos == #seq then
		@warp_to_first
	end
end

if v%(#seq-1) == 0 and pos[i] == #seq then
	@warp_to_first
end

@warp_to_first+=
for n=#seq-1,1,-1 do
	local k = pos2idx[n]
	pos2idx[n+1] = k
	pos[k] = pos[k] + 1
end
pos[i] = 1
pos2idx[1] = i

@move_backwards+=
for m=1,(-v)%(#seq-1) do
	local next_pos = pos[i] - 1
	
	if next_pos == 0 then
		@warp_to_last
		next_pos = #seq-1
	end

	local k = pos2idx[next_pos]
	pos2idx[pos[i]] = k
	pos2idx[pos[k]] = i
	pos[k], pos[i] = pos[i], pos[k]

	if next_pos == 1 then
		@warp_to_last
	end
end

if (-v)%(#seq-1) == 0 and pos[i] == 1 then
	@warp_to_last
end

@warp_to_last+=
for n=2,#seq do
	local k = pos2idx[n]
	pos2idx[n-1] = k
	pos[k] = pos[k] - 1
end
pos[i] = #seq
pos2idx[#seq] = i

@find_grove_coordinates+=
@find_zero_position
@find_groove_after_zero

@find_zero_position+=
local zero_pos
for i=1,#seq do
	if seq[i] == 0 then
		zero_pos = pos[i]
		break
	end
end

@find_groove_after_zero+=
local answer = 0
for _, offset in ipairs({1000, 2000, 3000}) do
	local j = (zero_pos + offset - 1) % #seq + 1
	answer = answer + seq[pos2idx[j]]
end

