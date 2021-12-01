@*=
@requires
@variables
@functions
@read_input
-- @read_test
@parse_input
@process_input
@process_input2
@display_result

@read_input+=
local lines = {}

for line in io.lines("input.txt") do
	table.insert(lines, line)
end

@read_test+=
local lines = {}

for line in io.lines("test2.txt") do
	table.insert(lines, line)
end

@parse_input+=
local rules = {}
local parents = {}
for _, line in ipairs(lines) do
	local words = {}
	for word in vim.gsplit(line, " ") do
		table.insert(words, word)
	end
	local rule = {}

	local name = words[1] .. " " .. words[2]
	if words[5] ~= "no" then
		@parse_containing_bags
	end
	rules[name] = rule
end

@parse_containing_bags+=
for i=5,#words,4 do
	local count = tonumber(words[i])
	local bag = words[i+1] .. " " .. words[i+2]
	parents[bag] = parents[bag] or {}
	table.insert(parents[bag], name)
	table.insert(rule, {count, bag})
end

@functions+=
function collect_parents(name, parents, candidates)
	candidates[name] = true
	if parents[name] then
		for _, p in ipairs(parents[name]) do
			if not candidates[p] then
				collect_parents(p, parents, candidates)
			end
		end
	end
end

@process_input+=
local candidates = {}
collect_parents("shiny gold", parents, candidates)
local num_containing = vim.tbl_count(candidates)-1

@functions+=
function countBags(name, rules)
	local count = 1
	if rules[name] then
		for _, rule in ipairs(rules[name]) do
			count = count + rule[1] * countBags(rule[2], rules)
		end
	end
	return count
end

@process_input2+=
local containing = countBags("shiny gold", rules) - 1

@display_result+=
print(containing)
