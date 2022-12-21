##aoc
@variables+=
local test_input = [[
root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32
]]
local answer_test1 = 152

@parts+=
function part1(lines, istest)
	@local_variables
	@read_monkeys
	@explore_and_reduce
	@return_root_shout
	return answer
end

@read_monkeys+=
for _, line in ipairs(lines) do
	@parse_name
	@parse_if_number
	@parse_if_op
end

@parse_name+=
local name, rest = line:match("(.+): (.+)")
name = vim.trim(name)
rest = vim.trim(rest)

@parse_if_number+=
if rest:match("%d") then
	local num = tonumber(rest)
	@save_num_monkey

@parse_if_op+=
else
	@read_references
	@save_references
	@save_op_monkey
end

@read_references+=
local ref1, op, ref2 = rest:match("(%S+) ([+-/*]) (%S+)")

@local_variables+=
local refs = {}

@save_references+=
refs[ref1] = refs[ref1] or {}
table.insert(refs[ref1], name)

refs[ref2] = refs[ref2] or {}
table.insert(refs[ref2], name)

@local_variables+=
local reduce = {}
local monkeys = {}
local yell = {}

@save_num_monkey+=
yell[name] = num
table.insert(reduce, name)

@save_op_monkey+=
monkeys[name] = { ref1, op, ref2 }

@explore_and_reduce+=
while #reduce > 0 do
	local new_reduce = {}
	for i=1,#reduce do
		@find_all_references_and_replace
	end
	reduce = new_reduce
end

@find_all_references_and_replace+=
local name = reduce[i]
if refs[name] then
	for _, ref in ipairs(refs[name]) do
		local ref_monkey = monkeys[ref]
		if ref_monkey then
			assert(type(ref_monkey) == "table")
			@if_left_replace_and_eventually_add_to_new
			@if_right_replace_and_eventually_add_to_new
		end
	end
end

@if_left_replace_and_eventually_add_to_new+=
if ref_monkey[1] == name then
	ref_monkey[1] = yell[name]
	@if_both_numbers_reduce

@if_right_replace_and_eventually_add_to_new
elseif ref_monkey[3] == name then
	ref_monkey[3] = yell[name]
	@if_both_numbers_reduce
else
	assert(false)
end

@if_both_numbers_reduce+=
if type(ref_monkey[1]) == "number" and type(ref_monkey[3]) == "number" then
	@do_operation
	yell[ref] = result
	table.insert(new_reduce, ref)
end

@do_operation+=
local result = 0
if ref_monkey[2] == '+' then
	result = ref_monkey[1] + ref_monkey[3]
elseif ref_monkey[2] == '-' then
	result = ref_monkey[1] - ref_monkey[3]
elseif ref_monkey[2] == '*' then
	result = ref_monkey[1] * ref_monkey[3]
elseif ref_monkey[2] == '/' then
	result = math.floor(ref_monkey[1] / ref_monkey[3])
end

@return_root_shout+=
local answer = yell["root"]
