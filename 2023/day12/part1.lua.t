##aoc
@variables+=
local test_input1 = [[
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
]]

local answer_test1 = 21

@parts+=
@define_functions
function part1(lines, istest)
	local answer
	@local_variables
	@foreach_line_find_arrangements
	return answer
end

@foreach_line_find_arrangements+=
local answer = 0
for _, line in ipairs(lines) do
	@parse_line
	@generate_all_possibilities
	@foreach_possibility_count_valid
	@add_posibility
end

@generate_all_possibilities+=
local poss = { "" }
local remain = line
while true do
	local n, _ = remain:find("?")
	@extract_substring
	@if_substring_append_to_all_possiblity
	@update_remain
	@if_none_remain_quit
	@append_two_possibility
	@update_remain_next
end

@extract_substring+=
local substr
if not n then
	substr = remain
else
	substr = remain:sub(1,n-1)
end

@if_substring_append_to_all_possiblity+=
if substr then
	for i=1,#poss do
		poss[i] = poss[i] .. substr
	end
end

@update_remain+=
if not n then
	remain = ""
else
	remain = remain:sub(n)
end

@if_none_remain_quit+=
if not remain or #remain == 0 then
	break
end

@append_two_possibility+=
local next_poss = {}
for i=1,#poss do
	table.insert(next_poss, poss[i] .. ".")
	table.insert(next_poss, poss[i] .. "#")
end
poss = next_poss

@update_remain_next+=
remain = remain:sub(2)

@foreach_possibility_count_valid+=
for i=1,#poss do
	@extract_sequence
	@match_to_reference_sequence
	@add_possibility_if_so
end

@parse_line+=
local elems = vim.split(line, "%s+", {trimempty=true})
line = elems[1]
local ref_seq = vim.tbl_map(tonumber, vim.split(elems[2], ","))

@extract_sequence+=
local p = poss[i]
local seq = {}
local c = 0
for j=1,#p do
	if p:sub(j,j) == "#" then
		c = c + 1
	else
		if c ~= 0 then
			table.insert(seq, c)
			c = 0
		end
	end
end

if c ~= 0 then
	table.insert(seq, c)
end

@match_to_reference_sequence+=
local ismatch = true
if #seq ~= #ref_seq then
	ismatch = false
else
	for k=1,#seq do
		if seq[k] ~= ref_seq[k] then
			ismatch = false
			break
		end
	end
end

@foreach_possibility_count_valid-=
local valid = 0

@add_possibility_if_so+=
if ismatch then
	valid = valid + 1 
end

@add_posibility+=
answer = answer + valid

