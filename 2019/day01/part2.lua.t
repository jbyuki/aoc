##aoc
@parts+=
function part2(lines)
	@convert_to_nums
	@compute_fuel_requirements_each_expanded
	@add_all_together
	return answer
end

@variables+=
local answer_test2 = 50346

@compute_fuel_requirements_each_expanded+=
nums = vim.tbl_map(function(num)
	local sum = 0
	while true do
		num = math.floor(num/3)-2
		if num <= 0 then
			break
		end
		sum = sum + num
	end
	return sum
end, nums)
