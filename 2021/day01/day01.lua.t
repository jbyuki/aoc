##day01
@day01.lua=
@read_input
@sum_to_sliding_window
@count_increase
@show_result

@read_input+=
nums = {}
for line in io.lines("input.txt") do
  table.insert(nums, tonumber(line))
end

@count_increase+=
answer = 0
for i=2,#nums do
  if nums[i] > nums[i-1] then
    answer = answer + 1
  end
end

@show_result+=
print("Answer is " .. answer)

@sum_to_sliding_window+=
sums = {}
for i=1,#nums-2 do
  table.insert(sums, nums[i]+nums[i+1]+nums[i+2])
end

nums = sums
