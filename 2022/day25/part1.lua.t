##aoc
@variables+=
local test_input = [[
1=-0-2
12111
2=0=
21
2=01
111
20012
112
1=-1=
1-12
12
1=
122
]]

local answer_test1 = "2=-1=0"

@parts+=
function part1(lines, istest)
	@local_variables
	@convert_to_snafu_and_sum
	@convert_sum_to_snafu
	return answer
end

@convert_to_snafu_and_sum+=
for _, line in ipairs(lines) do
	@convert_line_to_snafu
	@add_to_sum
end

@functions+=
function todec(line)
	local num = BigNum.new(0)
	for i=1,#line do
		local n = line:sub(i,i)
		num = num * 5
		if n == "2" or n == "1" or n == "0" then
			num = num + tonumber(n)
		elseif n == "=" then
			num = num - 2
		elseif n == "-" then
			num = num - 1
		end
	end
	return num
end

@requires+=
require "BigNum"

@convert_line_to_snafu+=
local num = todec(line)
print(num)

@local_variables+=
local sum = BigNum.new(0)

@add_to_sum+=
sum = sum + num

@functions+=
function tosnafu(num)
	local snafu = ""
	while num ~= BigNum.new(0) do
		local dec = num - ((num/5) * 5)
		if dec <= BigNum.new(2) then
			snafu = tostring(dec) .. snafu
		elseif dec == BigNum.new(3) then
			snafu = "=" .. snafu
			num = num + (5 - dec)
		elseif dec == BigNum.new(4) then
			snafu = "-" .. snafu
			num = num + (5 - dec)
		end
		num = num / 5
	end
	return snafu
end

@convert_sum_to_snafu+=
local answer = tosnafu(sum)
