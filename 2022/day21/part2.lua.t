##aoc
@variables+=
local answer_test2 = 301

@parts+=
function part2(lines, istest)
	@local_variables
	@read_monkeys
	@explore_and_reduce
	@find_path_from_humn_to_root
	@go_backward_along_path_and_find_humn
	return answer
end

@find_path_from_humn_to_root+=
local path = {}
local current = "humn"
while current ~= "root" do
	table.insert(path, current)
	local parents = refs[current]
	assert(parents and #parents == 1)
	current = parents[1]
end

@go_backward_along_path_and_find_humn+=
local must_match
@find_match_number

for i=#path,2,-1 do
	@if_path_is_left
	@if_path_is_right
end

@local_variables+=
local left = {}
local right = {}

@save_op_monkey+=
left[name] = ref1
right[name] = ref2

@if_path_is_left+=
if left[path[i]] == path[i-1] then
	@do_reverse_operation_left

@if_path_is_right+=
elseif right[path[i]] == path[i-1] then
	@do_reverse_operation_right
else
	assert(false)
end

@find_match_number+=
if left["root"] == path[#path] then
	must_match = yell[right["root"]]
elseif right["root"] == path[#path] then
	must_match = yell[left["root"]]
else
	assert(false)
end

@do_reverse_operation_left+=
local op = monkeys[path[i]][2]
if op == "+" then
	must_match = must_match - yell[right[path[i]]]
elseif op == "-" then
	must_match = must_match + yell[right[path[i]]]
elseif op == "*" then
	must_match = must_match / yell[right[path[i]]]
elseif op == "/" then
	must_match = must_match * yell[right[path[i]]]
else
	assert(op)
end

@do_reverse_operation_right+=
local op = monkeys[path[i]][2]
if op == "+" then
	must_match = must_match - yell[left[path[i]]]
elseif op == "-" then
	must_match = yell[left[path[i]]] - must_match
elseif op == "*" then
	must_match = must_match / yell[left[path[i]]]
elseif op == "/" then
	must_match = yell[left[path[i]]] / must_match
else
	assert(op)
end

@go_backward_along_path_and_find_humn+=
local answer = must_match
