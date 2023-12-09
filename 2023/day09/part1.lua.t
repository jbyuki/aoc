##aoc
@variables+=
local test_input1 = [[
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
]]

local answer_test1 = 114

@parts+=
@define_functions
function part1(lines, istest)
	local answer
	@local_variables
	@foreach_line_find_next_prediction
	return answer
end

@foreach_line_find_next_prediction+=
answer = 0
for _, line in ipairs(lines) do
	@parse_line
	@find_last_increment
	@add_up_to_find_prediction
	@add_prediction_to_answer
end

@parse_line+=
local nums = vim.tbl_map(tonumber, vim.split(line, "%s+", {trimempty=true}))

@find_last_increment+=
local history = {nums}
local last_seq = nums
while true do
	@stop_if_all_zeros
	@find_next_sequence
end

@stop_if_all_zeros+=
local all_zeros = true
for _, num in ipairs(last_seq) do
	if num ~= 0 then
		all_zeros = false
		break
	end
end

if all_zeros then
	break
end

@find_next_sequence+=
local next_seq = {}
for i=1,#last_seq-1 do
	table.insert(next_seq, last_seq[i+1] - last_seq[i])
end

table.insert(history, next_seq)
last_seq = next_seq

@add_up_to_find_prediction+=
local prediction = 0
for i=#history,1,-1 do
	local seq = history[i]
	prediction = prediction + seq[#seq]
end

@add_prediction_to_answer+=
answer = answer + prediction

