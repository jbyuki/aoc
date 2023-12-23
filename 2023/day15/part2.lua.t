##aoc
@variables+=
-- local test_input2 = [[
-- ]]

@variables+=
local answer_test2 = 145

@parts+=
@define_functions
function part2(lines, istest)
	@local_variables
	@separate_sequences
	@place_lenses
	@compute_focusing_power
	return answer
end

@place_lenses+=
local boxes = {}
for i=0,255 do
	boxes[i] = {}
end

for _, inst in ipairs(seqs) do
	local seq, op, fl = inst:match("(%a+)(.)(%d*)")
	@compute_hash
	if op == "-" then
		@remove_lens_in_box
	elseif op == "=" then
		@search_lens
		@if_found_replace
		@otherwise_put_in_back
	end
end

@remove_lens_in_box+=
local lenses = boxes[hash]
for i=1,#lenses do
	if lenses[i][1] == seq then
		table.remove(lenses, i)
		break
	end
end

@search_lens+=
local found
local lenses = boxes[hash]
for i=1,#lenses do
	if lenses[i][1] == seq then
		found = i
		break
	end
end

@if_found_replace+=
if found then
	lenses[found][2] = tonumber(fl)

@otherwise_put_in_back+=
else
	table.insert(lenses, { seq, tonumber(fl) })
end

@compute_focusing_power+=
local sum = 0
for i, box in pairs(boxes) do
	for j, lens in ipairs(box) do
		sum = sum + (i+1)*j*lens[2]
	end
end
answer = sum

