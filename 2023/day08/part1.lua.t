##aoc
@variables+=
local test_input = [[
LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
]]

local answer_test1 = 2

@parts+=
@define_functions
function part1(lines, istest)
	@local_variables
	@read_instruction
	@read_lookup
	@follow_instructions
	return answer
end

@read_instruction+=
local code = vim.trim(lines[1])

@read_lookup+=
for i=3,#lines do
	local line = lines[i]
	if #line > 0 then
		@read_lookup_line
		@add_lookup_line
	end
end

@read_lookup_line+=
local parsed = vim.split(line, "=")
local src = vim.trim(parsed[1])
local left, right = parsed[2]:match("(...)%s*,%s*(...)")

@local_variables+=
local lookup = {}

@add_lookup_line+=
lookup[src] = { left, right }

@follow_instructions+=
local answer = 0
local current = "AAA"
local ip = 1
local where = {
	L = 1,
	R = 2,
}

while current ~= "ZZZ" do
	if ip > #code then
		ip = 1
	end

	local inst = code:sub(ip,ip)
	current = lookup[current][where[inst]]
	ip = ip + 1
	answer = answer + 1
end

