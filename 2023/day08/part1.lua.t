##aoc
@variables+=
local test_input1 = [[
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
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

