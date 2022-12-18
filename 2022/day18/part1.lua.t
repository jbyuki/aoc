##aoc
@variables+=
local test_input = [[
2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5
]]
local answer_test1 = 64

@parts+=
function part1(lines, istest)
	@local_variables
	@fill_grid
	@foreach_cube_compute_sides
	return answer
end

@fill_grid+=
for _, line in ipairs(lines) do
	local x, y, z = unpack(vim.split(line, ","))
	x = tonumber(x)
	y = tonumber(y)
	z = tonumber(z)

	@fill_grid_cell
end

@local_variables+=
local grid = {}
local filled = {}

@fill_grid_cell+=
table.insert(filled, {x,y,z})

grid[x] = grid[x] or {}
grid[x][y] = grid[x][y] or {}
grid[x][y][z] = true

@functions+=
function has_cell(grid, x, y, z)
	if not grid[x] or not grid[x][y] or not grid[x][y][z] then
		return 1
	end
	return 0
end

@foreach_cube_compute_sides+=
local answer = 0
for _, fill in ipairs(filled) do
	local x, y, z = unpack(fill)
	answer = answer + has_cell(grid, x+1,y,z)
	answer = answer + has_cell(grid, x-1,y,z)
	answer = answer + has_cell(grid, x,y+1,z)
	answer = answer + has_cell(grid, x,y-1,z)
	answer = answer + has_cell(grid, x,y,z+1)
	answer = answer + has_cell(grid, x,y,z-1)
end

