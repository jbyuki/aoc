##aoc
@variables+=
local test_input1 = [[
rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
]]

local answer_test1 = 1320

@parts+=
@define_functions
function part1(lines, istest)
	local answer = 0
	@local_variables
	@separate_sequences
	@foreach_sequence_compute_hash
	@add_up_hashes
	return answer
end

@separate_sequences+=
local seqs = vim.split(lines[1], ",")

@foreach_sequence_compute_hash+=
local hashes = {}
for _, seq in pairs(seqs) do
	@compute_hash
	table.insert(hashes, hash)
end

@compute_hash+=
local value = 0
for i=1,#seq do
	local c = seq:sub(i,i)
	value = value + c:byte()
	value = value * 17
	value = value % 256
end

local hash = value

@add_up_hashes+=
local answer = 0
for _, hash in ipairs(hashes) do
	answer = answer + hash
end

