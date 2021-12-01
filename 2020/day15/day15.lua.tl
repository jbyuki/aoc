@*=
@requires
@variables
@functions
--@read_input
@read_test
@parse_input
@process_input
@display_result1
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
local start = {}
for num in vim.gsplit(lines[1], ",") do
	table.insert(start, tonumber(num))
end

@process_input+=
@say_start_values
@find_last_zero
@say_zero
@loop_for_next_values

@variables+=
local last = {}
local lz

@say_start_values+=
for i=1,#start do
	last[start[i]] = i
end

@find_last_zero+=
lz = last[0]

@say_zero+=
last[0] = #start+1

@loop_for_next_values+=
for i=#start+2, 30000000 do
	if not lz then
		@find_last_zero
		last[0] = i
		if i == 30000000 then print(0) end
	else
		@find_last_used
		last[v] = i
		if i == 30000000 then print(v) end
	end
end

@find_last_used+=
local v = (i-1)-lz
lz = last[v]
