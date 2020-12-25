@*=
@requires
@functions
@read_input
--@read_test
@solve_part_1
@solve_part_2
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

@solve_part_1+=
local card = tonumber(lines[1])
local device = tonumber(lines[2])

local cardloop, deviceloop

local val = 1
local i = 1
while i < 100000000 and (not cardloop or not deviceloop) do
	val = val * 7
	val = val % 20201227
	if val == card then
		cardloop = i
	end
	if val == device then
		deviceloop = i
	end
	i = i + 1
end

print("device " .. deviceloop)
print("card " .. cardloop)

local key = 1
for i=1,cardloop do
	key = key * device
	key = key % 20201227
end
print(key)

local key = 1
for i=1,deviceloop do
	key = key * card
	key = key % 20201227
end
print(key)
