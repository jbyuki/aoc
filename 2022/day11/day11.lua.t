@*=
@variables
@functions
@parts
@execute

@parts+=
function part1()
	@read_lines

	@parse_initial_monkey
	@simulate_20_rounds
	@find_two_most_active_monkeys_and_compute_monkey_buisness

	@show_answer
end

@read_lines+=
local lines = {}
for line in io.lines("input.txt") do
  table.insert(lines, line)
end

@parse_initial_monkey+=
for i=1,#lines+1,7 do
	local monkey = {}
	@read_starting_items
	@read_operation
	@read_test
	@read_throw_destination
	@init_monkey
	table.insert(monkeys, monkey)
end

@variables+=
local monkeys = {}

@read_starting_items+=
local s, _ = lines[i+1]:find(":")
local item_list = vim.split(lines[i+1]:sub(s+1), ",")
monkey.pending = vim.tbl_map(function(item) return tonumber(vim.trim(item)) end, item_list)

@read_operation+=
local s, _ = lines[i+2]:find(":")
monkey.op = vim.trim(lines[i+2]:sub(s+1))

@read_test+=
monkey.divisor = tonumber(lines[i+3]:match("by (%d+)"))

@read_throw_destination+=
monkey.if_true = tonumber(lines[i+4]:match("monkey (%d+)"))
monkey.if_false = tonumber(lines[i+5]:match("monkey (%d+)"))


@simulate_20_rounds+=
for i=1,20 do
	@inspect_every_monkey
end

@inspect_every_monkey+=
for j=1,#monkeys do
	local monkey = monkeys[j]
	while #monkey.pending > 0 do
		local item = monkey.pending[1]
		monkey.num_op = monkey.num_op + 1
		@apply_operation_on_item
		@divide_by_three
		@throw_to_appropriate_monkey
		table.remove(monkey.pending, 1)
	end
end

@apply_operation_on_item+=
old = item
local f, err = loadstring(monkey.op)
assert(f)
f()

@divide_by_three+=
local worry = math.floor(new/3)

@init_monkey+=
monkey.num_op = 0

@throw_to_appropriate_monkey+=
if worry % monkey.divisor == 0 then
	table.insert(monkeys[monkey.if_true+1].pending, worry)
else
	table.insert(monkeys[monkey.if_false+1].pending, worry)
end

@find_two_most_active_monkeys_and_compute_monkey_buisness+=
local ops = {}
for j=1,#monkeys do
	table.insert(ops, monkeys[j].num_op)
end

table.sort(ops)

local monkey_buisness = ops[#ops] * ops[#ops-1]

@show_answer+=
print(ops[#ops], ops[#ops-1], monkey_buisness)

@parts+=
function part2()
	@read_lines

	@parse_initial_monkey
	@compute_common_divisor
	@simulate_10000_rounds
	@find_two_most_active_monkeys_and_compute_monkey_buisness

	@show_answer
end

@simulate_10000_rounds+=
for i=1,10000 do
	@inspect_every_monkey_unbounded
end

@inspect_every_monkey_unbounded+=
for j=1,#monkeys do
	local monkey = monkeys[j]
	while #monkey.pending > 0 do
		local item = monkey.pending[1]
		monkey.num_op = monkey.num_op + 1
		@apply_operation_on_item
		@modulo_by_common_divisor
		@throw_to_appropriate_monkey
		table.remove(monkey.pending, 1)
	end
end

@compute_common_divisor+=
local common_divisor = 1
for j=1,#monkeys do
	common_divisor = common_divisor * monkeys[j].divisor
end

@modulo_by_common_divisor+=
local worry = new % common_divisor

@execute+=
part2()

