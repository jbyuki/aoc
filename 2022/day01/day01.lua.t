@*=
@variables
@read_each_line
@print_out_answer

@read_each_line+=
for line in io.lines("input.txt") do
	@if_number_add_to_sum
	@otherwise_check_if_max_sum_and_reset
end
@check_if_max_sum

@if_number_add_to_sum+=
if line:match("%d+") then
	local cal = tonumber(line)
	sum = sum + cal

@variables+=
local sum = 0
local sums = {}

@otherwise_check_if_max_sum_and_reset+=
else
	table.insert(sums, sum)
	sum = 0
end

@check_if_max_sum+=
table.insert(sums, sum)

@print_out_answer+=
table.sort(sums)
print(sums[#sums] + sums[#sums-1] + sums[#sums-2])
