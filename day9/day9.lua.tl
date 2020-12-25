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

for line in io.lines("test.txt") do
	table.insert(lines, line)
end

@parse_input+=
local nums = {}
for _, line in ipairs(lines) do
	table.insert(nums, tonumber(line))
end

@process_input+=
local off = 25
for i=off+1,#nums do
	@collect_previous_numbers
	@check_if_current_numbrer_is_sum
	@if_not_display_it_and_quit
end

@collect_previous_numbers+=
local prev = {}
for j=i-off,i-1 do
	prev[nums[j]] = prev[nums[j]] or 0
	prev[nums[j]] = prev[nums[j]] + 1
end

@check_if_current_numbrer_is_sum+=
local good = false
for p, v in pairs(prev) do
	local k = prev[nums[i]-p]
	if k then
		if nums[i]-p ~= p or v >= 2 then
			good = true
			break
		end
	end
end

@variables+=
local ans1

@if_not_display_it_and_quit+=
if not good then
	ans1 = nums[i]
	break
end

@process_input2+=
for i=1,#nums do
	local sum = 0
	for j=i,#nums do
		sum = sum + nums[j]
		if sum == ans1 and j-i > 0 then
			@compute_min_max_of_sum
			break
		elseif sum > ans1 then
			break
		end
	end
end

@compute_min_max_of_sum+=
local mini, maxi = nums[i], nums[j]
for k=i,j do 
	mini = math.min(mini, nums[k])
	maxi = math.max(maxi, nums[k])
end

print("mini " .. mini)
print("maxi " .. maxi)
print("ans " .. mini + maxi)
