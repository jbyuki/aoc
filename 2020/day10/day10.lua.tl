@*=
@requires
@variables
@functions
@read_input
-- @read_test
@parse_input
@process_input
@process_input2
@display_result

@read_input+=
local lines = {}

for line in io.lines("input.txt") do
	table.insert(lines, line)
end

@read_test+=
local lines = {}

for line in io.lines("test2.txt") do
	table.insert(lines, line)
end

@parse_input+=
local nums = {}
local present = {}
for _, line in ipairs(lines) do
	table.insert(nums, tonumber(line))
	present[tonumber(line)] = true
end

table.sort(nums)

@process_input+=
local diff1 = 0
local diff3 = 1
local prev = 0

for i=1,#nums do
	local diff = nums[i] - prev
	assert(diff >= 1 and diff <= 3, "wrong diff")
	prev = nums[i]
	if diff == 1 then
		diff1 = diff1 + 1
	elseif diff == 3 then
		diff3 = diff3 + 1
	end
end

@process_input2+=
@preprocess_count_number_of_connecting
@recursively_count_number_of_ways_with_memoization

@variables+=
local connect = {}
local builtin

@preprocess_count_number_of_connecting+=
connect[0] = {}
for i=1,3 do
	if present[i] then
		table.insert(connect[0], i)
	end
end

builtin = nums[#nums]+3

for _, num in ipairs(nums) do
	connect[num] = {}
	for i=num+1,num+3 do
		if present[i] or i == builtin then
			table.insert(connect[num], i)
		end
	end
end

@variables+=
local memo = {}

@requires+=
require("BigNum")

@functions+=
function count(x)
	if x == builtin then
		return 1
	end

	if memo[x] then
		return memo[x]
	end

	local s = BigNum.new(0)
	for _, n in ipairs(connect[x]) do
		s = s + count(n)
	end

	memo[x] = s
	return s
end

@recursively_count_number_of_ways_with_memoization+=
local res = count(0)

@display_result+=
print(res)

