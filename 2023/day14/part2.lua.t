##aoc
@variables+=
-- local test_input2 = [[
-- ]]

@variables+=
local answer_test2 = 64

@parts+=
@define_functions
function part2(lines, istest)
	@local_variables
	local occupied = {}
	@mark_all_stones
	@save_all_rocks

	local stones = vim.deepcopy(occupied)
	for i=1,10000 do
		@compute_load_part2
		@fill_map_with_rocks
		-- @show_map
		@detect_periodicity_for_map

		@slide_north
		@slide_west
		@slide_south
		@slide_east
	end

	return answer
end

@save_all_rocks+=
local locs = {}
for i=1,#lines do
	for j=1,#lines[1] do
		local cell = lines[i]:sub(j,j)
		if cell == "O" then
			table.insert(locs, {i,j})
		end
	end
end

@fill_map_with_rocks+=
local map = {}
for i=1,#lines do
	local row = {}
	for j=1,#lines[1] do
		table.insert(row, ".")
	end
	table.insert(map, row)
end

for _, loc in ipairs(locs) do
	local r,c = unpack(loc)
	map[r][c] = "O"
end

local concat = ""
for _, row in ipairs(map) do
	concat = concat .. table.concat(row)
end

@local_variables+=
local saved = {}

@detect_periodicity_for_map+=
if saved[concat] then
	print("PERIODIC!")
	local first = saved[concat]-1
	local second = i-1
	@compute_last_pattern
	break
end

saved[concat] = i
@save_load

@slide_north+=
local new_map = vim.deepcopy(occupied)
@fill_progressively_north
@fill_map_with_rocks

@fill_progressively_north+=
locs = {}
for i=1,#map do
	for j=1,#map[1] do
		local cell = map[i][j]
		if cell == "O" then
			local r = 0
			while true do
				if r-1+i >= 1 and (not new_map[r-1+i] or not new_map[r-1+i][j]) then
					r = r - 1
				else
					break
				end
			end

			new_map[i+r] = new_map[i+r] or {}
			new_map[i+r][j] = true
			table.insert(locs, {i+r, j})
		end
	end
end

@slide_west+=
local new_map = vim.deepcopy(occupied)
@fill_progressively_west
@fill_map_with_rocks

@slide_south+=
local new_map = vim.deepcopy(occupied)
@fill_progressively_south
@fill_map_with_rocks

@slide_east+=
local new_map = vim.deepcopy(occupied)
@fill_progressively_east

@fill_progressively_west+=
locs = {}
for i=1,#map do
	for j=1,#map[1] do
		local cell = map[i][j]
		if cell == "O" then
			local r = 0
			while true do
				if r-1+j >= 1 and (not new_map[i] or not new_map[i][r-1+j]) then
					r = r - 1
				else
					break
				end
			end

			new_map[i] = new_map[i] or {}
			new_map[i][r+j] = true
			table.insert(locs, {i, j+r})
		end
	end
end


@fill_progressively_south+=
locs = {}
for i=#map,1,-1 do
	for j=1,#map[1] do
		local cell = map[i][j]
		if cell == "O" then
			local r = 0
			while true do
				if r+1+i <= #map and (not new_map[r+1+i] or not new_map[r+1+i][j]) then
					r = r + 1
				else
					break
				end
			end

			new_map[i+r] = new_map[i+r] or {}
			new_map[i+r][j] = true
			table.insert(locs, {i+r, j})
		end
	end
end


@fill_progressively_east+=
locs = {}
for i=#map,1,-1 do
	for j=#map[1],1,-1 do
		local cell = map[i][j]
		if cell == "O" then
			local r = 0
			while true do
				if r+1+j <= #map[1] and (not new_map[i] or not new_map[i][r+1+j]) then
					r = r + 1
				else
					break
				end
			end

			new_map[i] = new_map[i] or {}
			new_map[i][j+r] = true
			table.insert(locs, {i, j+r})
		end
	end
end

@show_map+=
for _, row in ipairs(map) do
	print(table.concat(row))
end
print("--")

@compute_last_pattern+=
local last = 1000000000+1
local cycle = second - first
local rem = (last - first) % cycle

for v,c in pairs(saved) do
	if c == rem+first then
		answer = loads[c]
		break
	end
end

print(first, second, rem+first)
print(vim.inspect(loads[first]))

@local_variables+=
local loads = {}

@save_load+=
loads[i] = sum

@compute_load_part2+=
local sum = 0
for _,loc in ipairs(locs) do
	sum = sum + (#lines - (loc[1]-1))
end

