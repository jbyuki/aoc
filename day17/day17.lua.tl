@*=
@requires
@variables
@functions
@read_input
--@read_test
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
@init_grid
@fill_grid_with_input

@functions+=
function createHyperCube(len)
	local hypervolume = {}
	for w=1,len do
		local volume = {}
		for z=1,len do
			local grid = {}
			for y=1,len do
				local row = {}
				for x=1,len do
					table.insert(row, ".")
				end
				table.insert(grid, row)
			end
			table.insert(volume, grid)
		end
		table.insert(hypervolume, volume)
	end
	return hypervolume
end

@init_grid+=
local margin = 7
local len = string.len(lines[1])+margin*2
local hypervolume = createHyperCube(len)

@fill_grid_with_input+=
local startvolume = hypervolume[math.floor(#hypervolume/2)];
local startgrid = startvolume[math.floor(#startvolume/2)];
for y,line in ipairs(lines) do
	local row = startgrid[y+margin]
	for x=1,string.len(line) do
		local c = string.sub(line, x, x)
		row[x+margin] = c
	end
end

@process_input+=
@simulate_game_of_life
@count_alives

@simulate_game_of_life+=
for t=1,6 do
	-- @display_board_at_z_0
	@create_next_grid
	for w=1,#hypervolume do
		local volume = hypervolume[w]
		for z=1,#volume do
			local grid = volume[z]
			for y=1,#grid do
				local row = grid[y]
				for x=1,#row do
					@count_numbers_of_alive_neighbours
					@decide_fate_of_cells_base_on_count_neighbours
				end
			end
		end
	end
	@switch_next_grid
end

@count_numbers_of_alive_neighbours+=
local alive = 0
for dw=-1,1 do
	for dz=-1,1 do
		for dy=-1,1 do
			for dx=-1,1 do
				@if_own_cell_skip
				@if_out_of_bounds_skip
				@else_check_if_neighbour_is_alive
			end
		end
	end
end

@if_own_cell_skip+=
if dw == 0 and dx == 0 and dy == 0 and dz == 0 then

@if_out_of_bounds_skip+=
elseif dx+x > #row or dx+x < 1 or dy+y > #grid or dy+y < 1 or dz+z > #volume or dz+z < 1 or dw+w > #hypervolume or dw+w < 1 then

@else_check_if_neighbour_is_alive+=
else
	local c = hypervolume[w+dw][z+dz][y+dy][x+dx]
	if c == "#" then
		alive = alive + 1
	end
end

@decide_fate_of_cells_base_on_count_neighbours+=
local c = row[x]
if c == "#" then
	if alive == 2 or alive == 3 then
		next_hypervolume[w][z][y][x] = "#"
	else
		next_hypervolume[w][z][y][x] = "."
	end
else
	if alive == 3 then
		next_hypervolume[w][z][y][x] = "#"
	else
		next_hypervolume[w][z][y][x] = "."
	end
end

@count_alives+=
local remaining = 0
for w=1,#hypervolume do
	local volume = hypervolume[w]
	for z=1,#volume do
		local grid = volume[z]
		for y=1,#grid do
			local row = grid[y]
			for x=1,#row do
				if row[x] == "#" then
					remaining = remaining + 1
				end
			end
		end
	end
end

@display_result1+=
print(remaining)


@display_board_at_z_0+=
local startgrid = volume[math.floor(#volume/2)-1];
print("--- z = -1")
for _,row in ipairs(startgrid) do
	print(table.concat(row, ""))
end

local startgrid = volume[math.floor(#volume/2)];
print("--- z = 0")
for _,row in ipairs(startgrid) do
	print(table.concat(row, ""))
end

local startgrid = volume[math.floor(#volume/2)+1];
print("--- z = +1")
for _,row in ipairs(startgrid) do
	print(table.concat(row, ""))
end

@create_next_grid+=
local next_hypervolume = createHyperCube(len)

@switch_next_grid+=
hypervolume = next_hypervolume
