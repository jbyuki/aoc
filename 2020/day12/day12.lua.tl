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

for line in io.lines("test.txt") do
	table.insert(lines, line)
end

@process_input+=
local pos = { x = 0, y = 0 }
local dir = { x = 1, y = 0 }
for _, line in ipairs(lines) do
	local step = tonumber(string.sub(line, 2))

	if string.sub(line, 1, 1) == "R" then
		for i=1,step/90 do
			dir.x, dir.y = dir.y, -dir.x
		end
	elseif string.sub(line, 1, 1) == "L" then
		for i=1,step/90 do
			dir.x, dir.y = -dir.y, dir.x
		end
	elseif string.sub(line, 1, 1) == "F" then
		pos.x = pos.x + step * dir.x
		pos.y = pos.y + step * dir.y
	elseif string.sub(line, 1, 1) == "N" then
		pos.y = pos.y + step
	elseif string.sub(line, 1, 1) == "S" then
		pos.y = pos.y - step
	elseif string.sub(line, 1, 1) == "E" then
		pos.x = pos.x + step
	elseif string.sub(line, 1, 1) == "W" then
		pos.x = pos.x - step
	end
end

@display_result+=
print("E " .. math.abs(pos.x))
print("N " .. math.abs(pos.y))
print("Sum: " .. math.abs(pos.x) + math.abs(pos.y))

@process_input2+=
local pos = { x = 0, y = 0 }
local waypoint = { x = 10, y = 1 }

for _, line in ipairs(lines) do
	local step = tonumber(string.sub(line, 2))

	if string.sub(line, 1, 1) == "R" then
		for i=1,step/90 do
			waypoint.x, waypoint.y = waypoint.y, -waypoint.x
		end
	elseif string.sub(line, 1, 1) == "L" then
		for i=1,step/90 do
			waypoint.x, waypoint.y = -waypoint.y, waypoint.x
		end
	elseif string.sub(line, 1, 1) == "F" then
		pos.x = pos.x + step * waypoint.x
		pos.y = pos.y + step * waypoint.y
	elseif string.sub(line, 1, 1) == "N" then
		waypoint.y = waypoint.y + step
	elseif string.sub(line, 1, 1) == "S" then
		waypoint.y = waypoint.y - step
	elseif string.sub(line, 1, 1) == "E" then
		waypoint.x = waypoint.x + step
	elseif string.sub(line, 1, 1) == "W" then
		waypoint.x = waypoint.x - step
	end
end
