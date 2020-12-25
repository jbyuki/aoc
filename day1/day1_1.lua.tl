@*=
@requires
@variables
@read_input
@process_input
@display_result

@read_input+=
local nums = {}

for line in io.lines("day1/input1.txt") do
	table.insert(nums, tonumber(line))
end

for i=1,#nums do
	for j=i+1,#nums do
		for k=j+1,#nums do
			if nums[i] + nums[j] + nums[k] == 2020 then
				print("Answer is " .. nums[i] .. " " .. nums[j] .. " " .. nums[k])
				print("Multiplication is " .. (nums[i]*nums[j]*nums[k]))
				@hello
				break
			end
		end
	end
end

@hello+=
local a = 10
local b = 10 + 10
