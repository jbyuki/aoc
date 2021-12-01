@*=
@requires
@declare_functions
@variables
@tokens
@expressions
@functions
@read_input
--@read_test
@parse_input
@process_input
@display_result1
--@parse_input2
--@process_input2
--@display_result2

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
local rules = {}
local i = 1
while lines[i] ~= "" do
	local rule = {}
	@read_rule_number
	local g = string.find(desc, '"')
	if g then
		@parse_char_rule
	else
		@parse_rules_into_words
	end
	rules[rnum] = rule
	i = i+1
end
i = i+1
local messages = {}
while i <= #lines do
	table.insert(messages, lines[i])
	i = i+1
end

@functions+=
function split_numbers(str)
	local nums = {}
	for word in vim.gsplit(str, " ") do
		table.insert(nums, tonumber(word))
	end
	return nums
end

@parse_rules_into_words+=
local s = string.find(desc, "|")
if s then
	local left = split_numbers(string.sub(desc, 1, s-1))
	local right = split_numbers(string.sub(desc, s+1))
	rule = { left, right }
else
	local left = split_numbers(desc)
	rule = { left }
end

@read_rule_number+=
local rnum = tonumber(string.match(lines[i], "(%d+):"))
local t = string.find(lines[i], ":")
local desc = string.sub(lines[i], t+1)

@parse_char_rule+=
local c = string.sub(desc, g+1, g+1)
rule = c

@declare_functions+=
local match_rule

@functions+=
function match_rule(s, i, rules, rule)
	if i > string.len(s) then
		return {}
	end

	local is = {}
	if type(rule) == "table" then
		if #rule == 1 then
			@expand_serial_regex
		else
			@expand_conditional_regex
		end
	else
		@expand_char_regex
	end
	return is
end

@expand_serial_regex+=
is = { i }
for _,num in ipairs(rule[1]) do
	local nis = {}
	for _, ni in ipairs(is) do
		local ns = match_rule(s, ni, rules, rules[num])
		vim.list_extend(nis, ns)
	end
	is = nis
end

@expand_conditional_regex+=
local lis = {i}
for _,num in ipairs(rule[1]) do
	local nis = {}
	for _, ni in ipairs(lis) do
		local ns = match_rule(s, ni, rules, rules[num])
		vim.list_extend(nis, ns)
	end
	lis = nis
end

local ris = {i}
for _,num in ipairs(rule[2]) do
	local nis = {}
	for _, ni in ipairs(ris) do
		local ns = match_rule(s, ni, rules, rules[num])
		vim.list_extend(nis, ns)
	end
	ris = nis
end

is = lis
vim.list_extend(is, ris)

@expand_char_regex+=
if string.sub(s, i, i) == rule then
	is = { i+1 }
end

@process_input+=
local ans = 0
for _, msg in ipairs(messages) do
	is = match_rule(msg, 1, rules, rules[0])
	local found = false
	for _, i in ipairs(is) do
		if i == string.len(msg)+1 then
			ans = ans + 1
			break
		end
	end
end

@display_result1+=
print(ans)
