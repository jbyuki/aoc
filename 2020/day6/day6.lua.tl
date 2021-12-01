@*=
@requires
@variables
@functions
@read_input
-- @read_test
@process_input
@display_result

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

@process_input+=
local groups = {}
local group = {}
for _,line in ipairs(lines) do
	if line == "" then
		table.insert(groups, group)
		group = {}
	else
		table.insert(group, line)
	end
end
table.insert(groups, group)

@functions+=
function lenSet(x)
	local len = 0
	for _,_ in pairs(x) do
		len = len+1
	end
	return len
end

@process_input+=
local sum = 0
for _, g in ipairs(groups) do
	local len = 0
	for i=1,string.len(g[1]) do
		local c = string.sub(g[1], i, i)
		local missing = false
		for _,l in ipairs(g) do
			if not string.find(l, c) then
				missing = true
				break
			end
		end

		if not missing then
			len = len + 1
		end
	end
	print(len)
	sum = sum + len
end

@display_result+=
print(sum)
