@*=
@requires
@variables
@read_input
@process_input
@display_result


@read_input+=
local nums = {}

lines = {}
for line in io.lines("day2/input.txt") do
	local mini, maxi, letter, pass = string.match(line, "(%d+)%-(%d+) (%a): (%a+)")
	table.insert(lines, {tonumber(mini), tonumber(maxi), letter, pass})
end

@process_input+=
local valid = 0
for _, line in ipairs(lines) do
	local mini, maxi, letter, pass = unpack(line)
	@password_policy
end

@password_policy+=
local count = 0
if string.sub(pass, mini, mini) == letter then
	count = count + 1
end

if string.sub(pass, maxi, maxi) == letter then
	count = count + 1
end

if count == 1 then
	valid = valid + 1
end

@display_result+=
print(valid)
