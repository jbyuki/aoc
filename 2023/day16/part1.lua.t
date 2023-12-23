##aoc
@variables+=
local test_input1 = [[
.|...\....
|.-.\.....
.....|-...
........|.
..........
.........\
..../.\\..
.-.-/..|..
.|....-|.\
..//.|....
]]

local answer_test1 = 46

@parts+=
@define_functions
function part1(lines, istest)
	local answer = 0
	@local_variables
	local open = {{dir = {0, 1}, pos = {1,1}}}
	@do_bfs_with_beam
	@compute_energized
	return answer
end

@do_bfs_with_beam+=
local close = {}

while #open > 0 do
	@get_next_light
	@save_passed
	@advance_light
end

@get_next_light+=
local beam = open[1]
table.remove(open, 1)


@advance_light+=
local cell = lines[r]:sub(c,c)
local next = {}
if cell == "." then
	@pass_through
elseif cell == "\\" then
	@mirror_go_down
elseif cell == "/" then
	@mirror_go_up
elseif cell == "-" then
	@horizontal_splitter
elseif cell == "|" then
	@vertical_splitter
end

@add_next_if_new

@pass_through+=
table.insert(next, {dir = dir, pos = {r+dir[1], c+dir[2]}})

@mirror_go_down+=
if dir[1] == 0 and dir[2] == 1 then -- RIGHT
	table.insert(next, {dir = {1,0}, pos = {r+1, c}})
elseif dir[1] == 0 and dir[2] == -1 then -- LEFT
	table.insert(next, {dir = {-1,0}, pos = {r-1, c}})
elseif dir[1] == -1 and dir[2] == 0 then -- UP
	table.insert(next, {dir = {0,-1}, pos = {r, c-1}})
elseif dir[1] == 1 and dir[2] == 0 then -- DOWN
	table.insert(next, {dir = {0,1}, pos = {r, c+1}})
end

@mirror_go_up+=
if dir[1] == 0 and dir[2] == 1 then -- RIGHT
	table.insert(next, {dir = {-1,0}, pos = {r-1, c}})
elseif dir[1] == 0 and dir[2] == -1 then -- LEFT
	table.insert(next, {dir = {1,0}, pos = {r+1, c}})
elseif dir[1] == -1 and dir[2] == 0 then -- UP
	table.insert(next, {dir = {0,1}, pos = {r, c+1}})
elseif dir[1] == 1 and dir[2] == 0 then -- DOWN
	table.insert(next, {dir = {0,-1}, pos = {r, c-1}})
end

@horizontal_splitter+=
if dir[1] ~= 0 then -- UP/DOWN
	table.insert(next, {dir = {0,1}, pos = {r, c+1}})
	table.insert(next, {dir = {0,-1}, pos = {r, c-1}})
elseif dir[2] ~= 0 then -- LEFT/RIGHT
	@pass_through
end

@vertical_splitter+=
if dir[1] ~= 0 then -- UP/DOWN
	@pass_through
elseif dir[2] ~= 0 then -- LEFT/RIGHT
	table.insert(next, {dir = {1,0}, pos = {r+1, c}})
	table.insert(next, {dir = {-1,0}, pos = {r-1, c}})
end

@local_variables+=
local passed = {}

@save_passed+=
local dir = beam.dir
local r,c = unpack(beam.pos)
local idx = r*#lines[1] + c
passed[idx] = passed[idx] or {}
table.insert(passed[idx], dir)

@add_next_if_new+=
for _, b in ipairs(next) do
	if b.pos[1] >= 1 and b.pos[1] <= #lines and b.pos[2] >= 1 and b.pos[2] <= #lines[1] then
		local idx = b.pos[1]*#lines[1] + b.pos[2]
		local explored = false
		@look_if_already_explored
		if not explored then
			table.insert(open, b)
		end
	end
end

@look_if_already_explored+=
if passed[idx] then
	for _, d in ipairs(passed[idx]) do
		if d[1] == b.dir[1] and d[2] == b.dir[2] then
			explored = true
			break
		end
	end
end

@compute_energized+=
-- for i=1,#lines do
	-- local row = ""
	-- for j=1,#lines[1] do
		-- local idx = i*#lines[1] + j
		-- if passed[idx] then
			-- row = row .. "#"
		-- else
			-- row = row .. "."
		-- end
	-- end
	-- print(row)
-- end

answer = vim.tbl_count(passed)

