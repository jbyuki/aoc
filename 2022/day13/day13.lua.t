@*=
@variables
@functions
@parts
@execute

@parts+=
function part1()
	@local_variables
	@read_lines
	@read_line_pairs
	@compare_every_pair

	@show_answer
end

@read_lines+=
local lines = {}
for line in io.lines("input.txt") do
  table.insert(lines, line)
end

@local_variables+=
local ps = {}

@read_line_pairs+=
for i=1,#lines,3 do
	local first = vim.json.decode(lines[i])
	local second = vim.json.decode(lines[i+1])
	table.insert(ps, {first, second})
end

@local_variables+=
local sum = 0

@compare_every_pair+=
for idx, pair in ipairs(ps) do
	local order = compare(pair[1], pair[2])
	if order == "right" then
		sum = sum + idx
	end
end

@show_answer+=
print(sum)

@functions+=
function compare(list1, list2) 
	@if_both_integers
	@if_both_lists
	@if_left_is_integer
	@if_right_is_integer
	assert(false)
end

@if_both_integers+=
if type(list1) == "number" and type(list2) == "number" then
	local num1 = tonumber(list1)
	local num2 = tonumber(list2)
	if num1 < num2 then return "right"
	elseif num2 < num1 then return "not right"
	else return "continue" end

@if_both_lists+=
elseif type(list1) == "table" and type(list2) == "table" then
	for i=1,math.min(#list1,#list2) do
		local result = compare(list1[i], list2[i])
		if result ~= "continue" then
			return result
		end
	end
	
	if #list1 < #list2 then return "right"
	elseif #list2 < #list1 then return "not right"
	else return "continue" end

@if_left_is_integer+=
elseif type(list1) == "number" then
	return compare({list1}, list2)

@if_right_is_integer+=
elseif type(list2) == "number" then
	return compare(list1, {list2})
end

@parts+=
function part2()
	@local_variables
	@read_lines
	@read_line_pairs
	@make_table_with_all_pairs
	@append_divider_packets
	@sort_packets
	@find_location_of_divider_packets

	@show_answer
end

@local_variables+=
local packets = {}

@make_table_with_all_pairs+=
for _, p in ipairs(ps)  do
	table.insert(packets, p[1])
	table.insert(packets, p[2])
end

@append_divider_packets+=
table.insert(packets, {{2}})
table.insert(packets, {{6}})

@sort_packets+=
table.sort(packets, function(a,b) 
	return compare(a, b) == "right" 
end)

@find_location_of_divider_packets+=
local first, second
for idx, tbl in ipairs(packets) do
	local str = vim.json.encode(tbl)
	if str == "[[2]]" then
		first = idx
	elseif str == "[[6]]" then
		second = idx
	end
end
local sum = first * second

@execute+=
part2()
