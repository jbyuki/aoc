##aoc
@parts+=
function part1(lines)
	@convert_to_nums
	@compute_fuel_requirements_each
	@add_all_together
	return answer
end

@./test.txt=
100756
@variables+=
local answer_test1 = 33583

@convert_to_nums+=
local nums = vim.tbl_map(tonumber, lines)

@compute_fuel_requirements_each+=
nums = vim.tbl_map(function(num)
	return math.floor(num/3)-2
end, nums)

@add_all_together+=
local answer = 0
for i=1,#nums do
	answer = answer + nums[i]
end
