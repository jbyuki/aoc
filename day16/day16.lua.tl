@*=
@requires
@variables
@functions
@read_input
--@read_test
@parse_input
@process_input
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
local l = 1
local fields = {}
while string.len(lines[l]) > 0 do
	@parse_field_rules
	l = l + 1
end

l = l + 2

@parse_own_ticket

l = l + 3

local nearby = {}
while l <= #lines do
	@parse_nearby_tickets
	l = l + 1
end

@parse_field_rules+=
local name, r1, r2, r3, r4 = string.match(lines[l], "([^:]+): (%d+)%-(%d+) or (%d+)%-(%d+)")
table.insert(fields, { name = name, r1 = tonumber(r1), r2 = tonumber(r2), r3 = tonumber(r3), r4 = tonumber(r4) })

@parse_nearby_tickets+=
local nums = {}
for num in vim.gsplit(lines[l], ",") do
	table.insert(nums, tonumber(num))
end
table.insert(nearby, nums)

@process_input+=
local sum = 0
local invalid = {}
for i, ticket in ipairs(nearby) do
	for _, val in ipairs(ticket) do
		@check_if_val_is_in_any_ticket_range
		@add_to_invalid_if_not_ok
	end
end

@check_if_val_is_in_any_ticket_range+=
local ok = false
for _, rule in ipairs(fields) do
	if (val >= rule.r1 and val <= rule.r2) or (val >= rule.r3 and val <= rule.r4) then
		ok = true
		break
	end
end

if not ok then
	sum = sum + val
end

@display_result1+=
print(sum)

@parse_own_ticket+=
local myticket = {}
for num in vim.gsplit(lines[l], ",") do
	table.insert(myticket, tonumber(num))
end


@add_to_invalid_if_not_ok+=
if not ok then
	table.insert(invalid, i)
end

@process_input2+=
@remove_invalid_tickets
@for_each_column_find_which_field_is_valid
@by_elimination_find_corresponding_rule

@remove_invalid_tickets+=
for i=#invalid,1,-1 do
	table.remove(nearby, invalid[i])
end

@for_each_column_find_which_field_is_valid+=
local valids = {}
for i=1,#nearby[1] do
	local poss = {}
	for j, field in ipairs(fields) do
		local valid = true
		@check_for_every_line_in_col_if_valid
		if valid then
			table.insert(poss, j)
		end
	end
	table.insert(valids, poss)
end

@check_for_every_line_in_col_if_valid+=
for _, row in ipairs(nearby) do
	if not ((row[i] >= field.r1 and row[i] <= field.r2) or (row[i] >= field.r3 and row[i] <= field.r4)) then
		valid = false
		break
	end
end

@by_elimination_find_corresponding_rule+=
local answer = {}
while vim.tbl_count(answer) < #fields do
	@find_if_there_is_a_col_with_single_valid
	@remove_single_valid_from_other
	@add_to_answer_single_valid
end

@find_if_there_is_a_col_with_single_valid+=
local single, singleidx
for i, v in ipairs(valids) do
	if #v == 1 then
		single = v[1]
		singleidx = i
		break
	end
end

if not single then
	print("Early exit!")
	break
end

@remove_single_valid_from_other+=
for i=1,#valids do
	local row = valids[i]
	@find_index_of_single_in_row
	@if_found_remove_it_from_row
	valids[i] = row
end

@find_index_of_single_in_row+=
local idx
for j,val in ipairs(row) do
	if val == single then
		idx = j
		break
	end
end

@if_found_remove_it_from_row+=
if idx then
	table.remove(row, idx)
end

@add_to_answer_single_valid+=
answer[singleidx] = single
print("input " .. singleidx-1 .. " rule " .. single)

@display_result2+=
local mul = 1
for i=1,#myticket do
	if string.match(fields[answer[i]].name, "departure") then
		print(fields[answer[i]].name .. " " .. i)
		mul = mul * myticket[i]
	end
end
print(mul)
dump = mul
