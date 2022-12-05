@*=
@variables
@parts
@execute

@parts+=
function part1()
	@parse_lines
	@parse_stacks
	@parse_and_execute_instructions
	@show_answer_top_stacks
end

@parse_lines+=
local lines = {}
for line in io.lines("input.txt") do
	table.insert(lines, line)
end

@parse_stacks+=
local line_idx = 1
local desc = {}
while true do
	local line = lines[line_idx]
	if line == "" then
		line_idx = line_idx + 1
		break
	end
	table.insert(desc, line)
	line_idx = line_idx + 1
end

local nums = vim.split(desc[#desc], " ")
nums = vim.tbl_filter(function(a) return #a > 0 end, nums)
local num_stack = #nums

local stacks = {}
for j=1,num_stack do
	local stack = {}
	for i=1,#desc-1 do
		local elem = desc[i]:sub(2+(j-1)*4, 2+(j-1)*4)
		if vim.trim(elem) ~= "" then
			table.insert(stack, 1, elem)
		end
	end
	table.insert(stacks, stack)
end

@parse_and_execute_instructions+=
while line_idx <= #lines do
	local line = lines[line_idx]
	@parse_instruction
	@execute_instruction
	line_idx = line_idx + 1
end

@parse_instruction+=
local count, from, to = line:match("move (%d+) from (%d+) to (%d+)")

from = tonumber(from)
to = tonumber(to)
count = tonumber(count)

@execute_instruction+=
for k=1,count do
	local from_stack = stacks[from]
	local to_stack = stacks[to]

	table.insert(to_stack, from_stack[#from_stack])
	table.remove(from_stack)
end

@show_answer_top_stacks+=
local tops = {}
for i=1,num_stack do
	table.insert(tops, stacks[i][#stacks[i]])
end
print(table.concat(tops, ""))

@parts+=
function part2()
	@parse_lines
	@parse_stacks
	@parse_and_execute_instructions_9001
	@show_answer_top_stacks
end

@parse_and_execute_instructions_9001+=
while line_idx <= #lines do
	local line = lines[line_idx]
	@parse_instruction
	@execute_instruction_9001
	line_idx = line_idx + 1
end

@execute_instruction_9001+=
local temp = {}
for k=1,count do
	local from_stack = stacks[from]

	table.insert(temp, from_stack[#from_stack])
	table.remove(from_stack)
end

for k=1,count do
	local to_stack = stacks[to]
	table.insert(to_stack, temp[#temp])
	table.remove(temp)
end

@execute+=
part2()
