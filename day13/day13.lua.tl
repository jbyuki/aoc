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

@process_input+=
local dep = tonumber(lines[1])
local ids = {}
for id in vim.gsplit(lines[2], ",") do
	if id ~= "x" then
		table.insert(ids, tonumber(id))
	else
		table.insert(ids, 0)
	end
end

local min = ids[1]
local ans = 0
for _, id in ipairs(ids) do
	local wait = id - (dep%id)
	if wait < min then
		min = wait
		ans = id * wait
	end
end

@requires+=
require("BigNum")

@process_input2+=
local t = BigNum.new(ids[1])
local prev = BigNum.new(ids[1])
for i=2, #ids do
	if ids[i] ~= 0 then
		while true do
			local res, rem = BigNum.new(), BigNum.new()
			BigNum.div(t + (i-1), BigNum.new(ids[i]), res, rem)
			if tostring(rem) == "0" then
				break
			end
			t = t + prev
		end
		prev = prev * ids[i]
	end
end

@display_result+=
print(t)
