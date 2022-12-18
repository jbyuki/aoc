##aoc
@variables+=
local answer_test2 = 58

@parts+=
function part2(lines, istest)
	@local_variables
	@fill_grid
	@find_boundings
	@prepare_boundings
	@propage_boundings_inside
	@find_exterior_sides
	return answer
end

@find_boundings+=
local min_b = { math.huge, math.huge, math.huge }
local max_b = { -math.huge, -math.huge, -math.huge }

for _, f in ipairs(filled) do
	local x, y, z = unpack(f)
	min_b[1] = math.min(min_b[1], x-1)
	min_b[2] = math.min(min_b[2], y-1)
	min_b[3] = math.min(min_b[3], z-1)

	max_b[1] = math.max(max_b[1], x+1)
	max_b[2] = math.max(max_b[2], y+1)
	max_b[3] = math.max(max_b[3], z+1)
end

@prepare_boundings+=
local open = {}
for x=min_b[1],max_b[1] do
	for y=min_b[2],max_b[2] do
		for z=min_b[3],max_b[3] do
			if x == min_b[1] or x == max_b[1] or y == min_b[2] or y == max_b[2] or z == min_b[3] or z == max_b[3] then
				table.insert(open, {x,y,z})
				@add_as_exterior_bounding
			end
		end
	end
end

@local_variables+=
local exterior = {}

@functions+=
function add3d(grid, x, y, z)
	grid[x] = grid[x] or {}
	grid[x][y] = grid[x][y] or {}
	grid[x][y][z] = true
end

function has3d(grid, x, y, z)
	return grid[x] and grid[x][y] and grid[x][y][z]
end

@add_as_exterior_bounding+=
add3d(exterior, x, y, z)

@propage_boundings_inside+=
while #open > 0 do
	local new_open = {}
	@foreach_exterior_propagate
	open = new_open
end

@foreach_exterior_propagate+=
for i=1,#open do
	local px, py, pz = unpack(open[i])

	for dx=-1,1 do
		for dy=-1,1 do
			for dz=-1,1 do
				if math.abs(dx) + math.abs(dy) + math.abs(dz) == 1 then
					@check_within_bounds_then_add

				end
			end
		end
	end
end

@check_within_bounds_then_add+=
local x = px+dx
local y = py+dy
local z = pz+dz

if x >= min_b[1] and x <= max_b[1] and y >= min_b[2] and y <= max_b[2] and z >= min_b[3] and z <= max_b[3] then
	if not has3d(exterior, x, y, z) and not has3d(grid, x, y, z) then
		add3d(exterior, x, y, z)
		table.insert(new_open, {x,y,z})
	end
end

@functions+=
function bool2int(b)
	return b and 1 or 0
end

@find_exterior_sides+=
local answer = 0
for _, f in ipairs(filled) do
	local x,y,z = unpack(f)
	answer = answer + bool2int(not has3d(grid, x+1, y, z) and has3d(exterior, x+1, y, z))
	answer = answer + bool2int(not has3d(grid, x-1, y, z) and has3d(exterior, x-1, y, z))
	answer = answer + bool2int(not has3d(grid, x, y+1, z) and has3d(exterior, x, y+1, z))
	answer = answer + bool2int(not has3d(grid, x, y-1, z) and has3d(exterior, x, y-1, z))
	answer = answer + bool2int(not has3d(grid, x, y, z-1) and has3d(exterior, x, y, z-1))
	answer = answer + bool2int(not has3d(grid, x, y, z+1) and has3d(exterior, x, y, z+1))
end

