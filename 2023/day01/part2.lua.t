##aoc
@variables+=
local answer_test2 = 55

@parts+=
function part2(lines, istest)
	local answer
	@local_variables
	@process_augmented
	return answer
end

@local_variables+=
local lookup = {
	one = 1,
	two = 2,
	three = 3,
	four = 4,
	five = 5,
	six = 6,
	seven = 7,
	eight = 8,
	nine = 9,
}

@process_augmented+=
local sum = 0
for _, line in ipairs(lines) do
	if #line >= 2 then
		@find_first_digit
		@find_last_digit
		sum = sum + tonumber(first .. last)
	end
end
answer = sum

@find_first_digit+=
local best_first = #line+1
local first = ""
for k, v in pairs(lookup) do
	i,j = line:find(k)
	if i and i < best_first then
		first = tostring(v)
		best_first = i
	end
end

for i=1,#line do
	if tonumber(line:sub(i,i)) then
		if i < best_first then
			best_first = i
			first = line:sub(i,i)
		end
		break
	end
end

@find_last_digit+=
local best_last = -10
local last = ""

for i=#line,1,-1 do
	if tonumber(line:sub(i,i)) then
		if i > best_last then
			best_last = i
			last = line:sub(i,i)
		end
		break
	end
end

for k, v in pairs(lookup) do
	i,j = line:find(".*" .. k)
	if j and j-#k+1 > best_last then
		last = tostring(v)
		best_last = j-#k+1
	end
end


