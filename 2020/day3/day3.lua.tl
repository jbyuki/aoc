@*=
@requires
@variables
@functions
@read_input
@process_input
@display_result

@variables+=
grid = {}

@read_input+=
for line in io.lines("input.txt") do
	table.insert(grid, line)
end

@functions+=
function numTree(dx, dy)
	local tree = 0
	local y, x = 1, 1
	while y <= #grid do
		local line = grid[y]
		local istree = string.sub(line, x, x)
		if istree == '#' then
			tree = tree + 1
		end
		x = x + dx
		if x > string.len(line) then
			x = x - string.len(line)
		end
		y = y + dy
	end
	return tree
end

@process_input+=
local result = 1
result = result * numTree(1, 1)
result = result * numTree(3, 1)
result = result * numTree(5, 1)
result = result * numTree(7, 1)
result = result * numTree(1, 2)

@display_result+=
print(result)
