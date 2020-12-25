@*=
@requires
@variables
@functions
@read_input
--@read_test
@parse_input
--@process_input
--@display_result1
@process_input2
@display_result2

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


@parse_input+=
local program = {}
for _, line in ipairs(lines) do
	local ins = {}
	if string.match(line, "^mask") then
		@parse_mask_instruction
		@add_instruction
	elseif string.match(line, "^mem") then
		@parse_mem_instruction
		@add_instruction
	else
		error("Unknown instruction " .. line)
	end
end

@parse_mask_instruction+=
local mask = string.match(line, "mask = ([01X]+)")
ins.op = "mask"
ins.mask = mask

@add_instruction+=
table.insert(program, ins)

@parse_mem_instruction+=
local add, val = string.match(line, "mem%[(%d+)%] = (%d+)")
ins.op = "mem"
ins.add = add
ins.val = val

@process_input+=
local mask
local mem = {}
for _, ins in ipairs(program) do
	@if_mask_change_current_mask
	@if_mem_change_mem_value
end

@if_mask_change_current_mask+=
if ins.op == "mask" then
	mask = ins.mask
end

@if_mem_change_mem_value+=
if ins.op == "mem" then
	@apply_mask_to_mem_value
	@assign_val_to_mem_indicated_by_add
end

@requires+=
local bit = require("bit")
require("BigNum")

@functions+=
function getBitAt(x, n)
	for _=1,n do
		x = bit.rshift(x, 1)
	end
	return bit.band(x, 1)
end

@apply_mask_to_mem_value+=
local val = BigNum.new(0)
for i=1,36 do
	val = val * 2

	local bmask = string.sub(mask, i, i)
	if bmask == "0" then
		val = val + 0
	elseif bmask == "1" then
		val = val + 1
	else
		val = val + getBitAt(ins.val, 36-i)
	end
end

@assign_val_to_mem_indicated_by_add+=
mem[ins.add] = val

@process_input+=
local sum = 0
for _, val in pairs(mem) do
	sum = sum + val
end

@display_result1+=
print("sum is " .. tostring(sum))

@process_input2+=
local mask
local mem = {}
for _, ins in ipairs(program) do
	@if_mask_change_current_mask
	if ins.op == "mem" then
		@decode_memory_address
		@find_all_valid_memory_address
		@write_all_all_places_for_decoded
	end
end


@decode_memory_address+=
local decoded = ""
for i=1,36 do
	local bmask = string.sub(mask, i, i)
	if bmask == "0" then
		decoded = decoded .. tostring(getBitAt(ins.add, 36-i))
	elseif bmask == "1" then
		decoded = decoded .. "1"
	elseif bmask == "X" then
		decoded = decoded .. "X"
	end
end

@find_all_valid_memory_address+=
local valid = {}
local fbadd = string.sub(decoded, 1, 1) 
if fbadd == "0" or fbadd == "1" then
	valid = { tonumber(fbadd) }
else
	valid = { 0, 1 }
end

for i=2,36 do
	local badd = string.sub(decoded, i, i) 
	local new_valid = {}
	if badd == "0" or badd == "1" then
		for _, v in ipairs(valid) do
			table.insert(new_valid, 2*v+tonumber(badd))
		end
	else
		for _, v in ipairs(valid) do
			table.insert(new_valid, 2*v+1)
			table.insert(new_valid, 2*v+0)
		end
	end
	valid = new_valid
end

@write_all_all_places_for_decoded+=
for _, v in ipairs(valid) do
	mem[v] = ins.val
end

@process_input2+=
local sum = 0
for _, val in pairs(mem) do
	sum = sum + val
end

@display_result2+=
print("sum is " .. sum)
