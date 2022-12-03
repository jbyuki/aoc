@*=
@variables
@functions
@parts
@execute

@parts+=
function part1()
	@read_input_part1
	@show_answer
end

@read_input_part1+=
for line in io.lines("input.txt") do
	@split_in_half
	@find_common_first_second
	@find_priority_of_common
	@add_to_total
end

@split_in_half+=
local half_len = math.floor(#line/2)
local first = line:sub(1,half_len)
local second = line:sub(half_len+1)

@functions+=
function find_common(first, second)
	@find_common
	return common
end

@find_common_first_second+=
local common = find_common(first, second)

@find_common+=
local first_set = {}
for i=1,#first do
	first_set[first:sub(i,i)] = true
end

local common = ""
for i=1,#second do
	if first_set[second:sub(i,i)] then
		common = common .. second:sub(i,i)
	end
end

assert(common ~= "")

@find_priority_of_common+=
local priority
if common:match("%l") then
	priority = common:byte() - ("a"):byte() + 1
elseif common:match("%u") then
	priority = common:byte() - ("A"):byte() + 1 + 26
end

@variables+=
local total = 0

@add_to_total+=
total = total + priority

@show_answer+=
print(total)

@parts+=
function part2()
	@read_input_part2
	@show_answer
end

@read_input_part2+=
local index = 0
for line in io.lines("input.txt") do
	@if_new_group_store_line
	@if_second_line_find_common
	@if_third_line_find_common_with_common_and_save
	index = index + 1
end

@variables+=
local first_line

@if_new_group_store_line+=
if index % 3 == 0 then
	first_line = line

@variables+=
local common_first_two

@if_second_line_find_common+=
elseif index % 3 == 1 then
	common_first_two = find_common(first_line, line)

@if_third_line_find_common_with_common_and_save+=
else
	all_common = find_common(common_first_two, line)
	assert(#all_common >= 1)
	local common = all_common
	@find_priority_of_common
	@add_to_total
end

@execute+=
part2()
