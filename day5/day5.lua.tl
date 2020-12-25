@*=
@requires
@variables
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
local reserved = {}
for _,line in ipairs(lines) do
	local id = 0
	@compute_row
	@compute_col
	@fill_reserved
end

@compute_row+=
for i=1,7 do
	local c = string.sub(line, i, i)
	id = id * 2
	if c == 'B' then id = id + 1 end
end

@compute_col+=
for i=1,3 do
	local c = string.sub(line, i+7, i+7)
	id = id * 2
	if c == 'R' then id = id + 1 end
end

@fill_reserved+=
reserved[id] = true

@process_input+=
for i=0,2^10-1 do
	if not reserved[i] and reserved[i-1] and reserved[i+1] then
		print("Missing " .. i)
	end
end
