##day25
@day25.lua=
@variables
@functions
@read_map
local step = 1
while true do
  local moved = false
  -- @show_map
  @create_empty_map
  @simulate_step_east
  @copy_next_to_current
  @create_empty_map
  @simulate_step_south
  @copy_next_to_current
  if not moved then
    break
  end
  step = step + 1
end
@show_result

@read_map+=
local map = {}
for line in io.lines("input.txt") do
  table.insert(map, vim.split(line, ""))
end

@create_empty_map+=
local next_map = vim.deepcopy(map)

@read_map+=
local h = #map
local w = #map[1]

@simulate_step_east+=
for y=1,h do
  for x=1,w do
    @check_if_east_sea_cucumber
  end
end

@simulate_step_south+=
for y=1,h do
  for x=1,w do
    @check_if_south_sea_cucumber
  end
end

@check_if_east_sea_cucumber+=
if map[y][x] == ">" then
  @check_if_east_empty
  if empty then
    @move_in_next_east
    moved = true
  end
end

@check_if_south_sea_cucumber+=
if map[y][x] == "v" then
  @check_if_south_empty
  if empty then
    @move_in_next_south
    moved = true
  end
end

@check_if_east_empty+=
local nx = x+1
if nx > w then
  nx = 1
end
local empty = map[y][nx] == "."

@move_in_next_east+=
next_map[y][nx] = ">"
next_map[y][x] = "."

@check_if_south_empty+=
local ny = y+1
if ny > h then
  ny = 1
end
local empty = map[ny][x] == "."

@move_in_next_south+=
next_map[ny][x] = "v"
next_map[y][x] = "."

@copy_next_to_current+=
map = next_map

@show_result+=
print(("%d steps"):format(step))

@show_map+=
print("--")
for _, row in ipairs(map) do
  print(table.concat(row))
end
