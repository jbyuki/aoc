##aoc
@variables+=
local test_input = [[
s5
]]

local answer_test1 = 142

@parts+=
function part1(lines, istest)
	local answer
	@local_variables
	@parse_input
	@process
	return answer
end

@process+=
local sum = 0
for _, line in ipairs(lines) do
	if #line >= 2 then
		local digits = {}
		for i=1,#line do
			if tonumber(line:sub(i,i)) then
				table.insert(digits, line:sub(i,i))
			end
		end
		local num = tonumber(digits[1] .. digits[#digits])
		sum = sum + num
	end
end
answer = sum
