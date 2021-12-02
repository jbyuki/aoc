##day02
@day02.lua=
@variables
@read_input
@show_result

@read_input+=
for line in io.lines("input.txt") do
  @parse_line
  if cmd == "forward" then
    @go_forward
    @go_aim
  elseif cmd == "up" then
    -- @go_up
    @change_aim_up
  elseif cmd == "down" then
    -- @go_down
    @change_aim_down
  end
end

@parse_line+=
local parsed = vim.split(line, " ")
local cmd = parsed[1]
local amount = tonumber(parsed[2])

@variables+=
local x = 0
local y = 0

@go_forward+=
x = x + amount

@go_up+=
y = y - amount

@go_down+=
y = y + amount

@show_result+=
print("answer is " .. (x * y))

@variables+=
aim = 0

@change_aim_up+=
aim = aim - amount

@change_aim_down+=
aim = aim + amount

@go_aim+=
y = y + aim*amount
