@*=
@requires
@declare_functions
@variables
@tokens
@expressions
@functions
@read_input
--@read_test
@parse_input
@process_input
-- @display_result1
@parse_input2
@process_input2
@display_result2

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
local i = 1
local tiles = {}
while i <= #lines do
	local tile = {}
	@read_single_tile
	tiles[id] = tile
end

@read_single_tile+=
local id = tonumber(string.match(lines[i], "Tile (%d+):"))
for j=1,10 do
	local row = lines[i+j]
	table.insert(tile, row)
end
i = i + 12

@process_input+=
for id, tile in pairs(tiles) do
	@read_four_borders
end

@functions+=
function get_col(array, col)
	local res = ""
	for i=1,#array do
		res = res .. string.sub(array[i], col, col)
	end
	return res
end

@variables+=
local borders = {}


@functions+=
function add_border(b, id)
	borders[b] = borders[b] or {}
	table.insert(borders[b], id)
	local br = string.reverse(b)
	borders[br] = borders[br] or {}
	table.insert(borders[br], id)
end

@read_four_borders+=
add_border(tile[1], id)
add_border(tile[10], id)
add_border(get_col(tile, 1), id)
add_border(get_col(tile, 10), id)

@process_input+=
local corners = {}
for id, tile in pairs(tiles) do
	local missing = 0

	if #borders[tile[1]] == 1 and borders[tile[1]][1] == id then
		missing = missing + 1
	end

	if #borders[tile[10]] == 1 and borders[tile[10]][1] == id then
		missing = missing + 1
	end

	if #borders[get_col(tile, 1)] == 1 and borders[get_col(tile, 1)][1] == id then
		missing = missing + 1
	end

	if #borders[get_col(tile, 10)] == 1 and borders[get_col(tile, 10)][1] == id then
		missing = missing + 1
	end

	if missing == 2 then
		table.insert(corners, id)
	end
end

@display_result1+=
local mul = 1
for _, id in ipairs(singles) do
	mul = mul * id
end
print(mul)

@process_input2+=
local grid2 = {}
local len = math.sqrt(vim.tbl_count(tiles))
local image = {}
local top
local side

for y=1,len do
	local row = {}
	for x=1,len do
		local cell
		if x == 1 then
			@find_corresponding_first_border
		else
			@find_corresponding_subsequent_borders
			@rotate_until_side_match
			@flip_if_side_not_match
			@replace_for_next_side_cell
		end
		table.insert(row, cell)
	end
	table.insert(image, row)
end

@functions+=
-- clockwise
function rotate(tile)
	local new_tile = {}
	for i=1,string.len(tile[1]) do
		local col = get_col(tile, i)
		table.insert(new_tile, string.reverse(col))
	end
	return new_tile
end

@variables+=
local topid, sideid

@find_corresponding_first_border+=
if not top then
	@rotate_until_left_and_top_non_matching
else
	@rotate_until_top_match
	@flip_if_top_doesnt_match
end
top = cell[10]
side = get_col(cell, 10)

@rotate_until_left_and_top_non_matching+=
cell = tiles[corners[1]]
topid = corners[1]
sideid = corners[1]
local found = false
for i=1,4 do
	if #borders[cell[1]] == 1 and #borders[get_col(cell, 1)] == 1 then
		found = true
		break
	end
	cell = rotate(cell)
end
assert(found, "Could not find valid orientation for corner")

@functions+=
function find_matching(border, id)
	local ids = borders[border]
	if ids[1] == id then
		return ids[2]
	else
		return ids[1]
	end
end

@rotate_until_top_match+=
local match = find_matching(top, topid)
cell = tiles[match]
topid = match
sideid = match

local found = false
for i=1,4 do
	if cell[1] == top or string.reverse(cell[1]) == top then
		found = true
		break
	end
	cell = rotate(cell)
end
assert(found, "didn't find correct orientation!")

@functions+=
function flipHori(tile)
	local rows = {}
	for i=1,#tile do
		table.insert(rows, string.reverse(tile[i]))
	end
	return rows
end

@flip_if_top_doesnt_match+=
if string.reverse(cell[1]) == top then
	cell = flipHori(cell)
end

@find_corresponding_subsequent_borders+=
local match = find_matching(side, sideid)
cell = tiles[match]
sideid = match

@rotate_until_side_match+=
local found = false
for i=1,4 do
	if get_col(cell, 1) == side or string.reverse(get_col(cell, 1)) == side then
		found = true
		break
	end
	cell = rotate(cell)
end
assert(found, "didn't find correct orientation!")

@functions+=
function flipVert(tile)
	local rows = {}
	for i=#tile,1,-1 do
		table.insert(rows, tile[i])
	end
	return rows
end

@flip_if_side_not_match+=
if get_col(cell, 1) ~= side then
	cell = flipVert(cell)
end

@replace_for_next_side_cell+=
side = get_col(cell, 10)

@process_input2+=
local assembled = {}
for y=1,len do
	for sy=2,9 do
		local superrow = ""
		@concat_every_row_of_every_cell_in_row
		table.insert(assembled, superrow)
	end
end


@concat_every_row_of_every_cell_in_row+=
for x=1,len do
	local cell = image[y][x]
	superrow = superrow .. string.sub(cell[sy], 2, 9)
end


@functions+=
function countMonsters(image)
	local len = 10
	local monster = {
		"                  # ",
		"#    ##    ##    ###",
		" #  #  #  #  #  #   ",
	}

	local len = string.len(image[1])
	local mon_len = string.len(monster[1])

	local count = 0
	for y=1,#image-#monster+1 do
		for x=1,len-mon_len+1 do
			local match = true
			@match_with_monster
			if match then
				count = count+1
			end
		end
	end
	return count
end

@match_with_monster+=
for dy=1,#monster do
	for dx=1,mon_len do
		local m = string.sub(monster[dy], dx, dx)
		if m == "#" then
			@check_if_match_with_image
		end
	end
end

@check_if_match_with_image+=
local p = string.sub(image[y+dy-1], x+dx-1, x+dx-1)
if p == "." then
	match = false
	break
end

@process_input2+=
local mon_count = 0
for i=1,4 do
	local cur_count = countMonsters(assembled)
	mon_count = math.max(cur_count, mon_count)
	if mon_count > 0 then
		break
	end
	local cur_count = countMonsters(flipHori(assembled))
	mon_count = math.max(cur_count, mon_count)
	if mon_count > 0 then
		print("Flipped!")
		assembled = flipHori(assembled)
		break
	end
	assembled = rotate(assembled)
end

@functions+=
function countSymbol(image, c)
	local count = 0 
	for _, row in ipairs(image) do
		for m in string.gmatch(row, c) do
			count = count + 1 
		end
	end
	return count
end

function countMatched(image) 
	local monster = {
		"                  # ",
		"#    ##    ##    ###",
		" #  #  #  #  #  #   ",
	}

	local len = string.len(image[1])
	local mon_len = string.len(monster[1])

	local cross = {}

	local count = 0
	for y=1,#image-#monster+1 do
		for x=1,len-mon_len+1 do
			local match = true
			@match_with_monster
			if match then
				@add_monsters_cross_into_cross
			end
		end
	end
	return vim.tbl_count(cross)
end

@add_monsters_cross_into_cross+=
for dy=1,#monster do
	for dx=1,mon_len do
		local m = string.sub(monster[dy], dx, dx)
		if m == "#" then
			local p = (y+dy-1)*#image+(x+dx-1)
			cross[p] = true
		end
	end
end

@display_result2+=
local total = countSymbol(assembled, "#")
local crossed = countMatched(assembled)
print(total)
print(crossed)
print(total-crossed)
