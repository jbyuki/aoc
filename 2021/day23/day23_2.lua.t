##day23_2
@day23_2.lua=
@variables
@functions
@read_input
@parse_input
@set_initial_state
@search_dp
@show_result

@read_input+=
local lines = {}
for line in io.lines("input2.txt") do
  table.insert(lines, line)
end

@parse_input+=
local grid = {}
for y,line in ipairs(lines) do
  for x=1,#line do
    @set_state_in_grid
  end
end

@set_state_in_grid+=
local c = line:sub(x, x)
if c:match("%u") then
  grid[y] = grid[y] or {}
  grid[y][x] = c
end

@set_initial_state+=
local state = {
  grid = grid,
  energy = 0,
  history = {},
}

table.insert(open, state)

@variables+=
local open = {}

@search_dp+=
local it = 1
while #open > 0 and it < 10000000 do
  @get_last_on_open
  if cur.placed == 16 then
    @add_completed
  else
    @search_possibilities_for_open
  end
  it = it + 1
end
for _, s in ipairs(open) do
  print(s.energy)
end
-- show_grid(open[#open].grid)
print(#open)

@functions+=
function show_grid(grid)
  for y=1,7 do
    local line = ""
    for x=1,13 do
      line = line .. ((grid[y] and grid[y][x]) or ".")
    end
    print(line)
  end
end

@get_last_on_open+=
local cur = open[#open]
table.remove(open)

@search_possibilities_for_open+=
local grid = cur.grid
for y,row in pairs(grid) do
  for x,c in pairs(row) do
    if y == 2 then
      @check_if_can_move_in_place
    else
      @check_if_free_above
      if free_above then
        @check_if_not_in_good_column_or_others
        if to_move then
          @move_in_corridor
        end
      end
    end
  end
end

@variables+=
local loc = {}
loc["A"] = 4
loc["B"] = 6
loc["C"] = 8
loc["D"] = 10

@check_if_can_move_in_place+=
local nx = loc[c] 
local mag = math.abs(nx - x)
local dir = (nx - x)/mag -- -1 or +1

local ok = true
for i=1,mag do
  if grid[y][x+i*dir] then
    ok = false
    break
  end
end

local ny = 6
if ok then
  @check_that_can_stack
end

if ok then
  @create_state_where_move_in_place
end

@check_that_can_stack+=
while true do
  if not grid[ny][nx] then
    break
  end

  if grid[ny][nx] ~= c then
    ok = false
    break
  end
  ny = ny - 1
end

@variables+=
local cost = {}
cost["A"] = 1
cost["B"] = 10
cost["C"] = 100
cost["D"] = 1000

@create_state_where_move_in_place+=
local next_state = vim.deepcopy(cur)
next_state.grid[y][x] = nil
next_state.grid[ny] = next_state.grid[ny] or {}
next_state.grid[ny][nx] = c
next_state.placed = next_state.placed + 1
next_state.energy = next_state.energy + (mag + ny-2)*cost[c]
@update_history
table.insert(open, next_state)

@check_if_free_above+=
local free_above = true
for ny=y-1,3,-1 do
  if grid[ny][x] then
    free_above = false
    break
  end
end

@check_if_not_in_good_column_or_others+=
local to_move = false
local nx = loc[c]
if nx ~= x then
  to_move = true
else
  for ny=y+1,6 do
    if grid[ny][x] ~= c then
      to_move = true
      break
    end
  end
end

@move_in_corridor+=
@move_to_left
@move_to_right

@variables+=
local entrance = {}
entrance[4] = true
entrance[6] = true
entrance[8] = true
entrance[10] = true

@move_to_left+=
for nx=x-1,2,-1 do
  if not entrance[nx] then
    if grid[2] and grid[2][nx] then
      break
    else
      @create_next_state_move_in_corridor
    end
  end
end

@create_next_state_move_in_corridor+=
local next_state = vim.deepcopy(cur)
next_state.grid[y][x] = nil
next_state.grid[2] = next_state.grid[2] or {}
next_state.grid[2][nx] = c
next_state.energy = next_state.energy + (math.abs(nx-x) + y-2)*cost[c]
@update_history
table.insert(open, next_state)

@move_to_right+=
for nx=x+1,12 do
  if not entrance[nx] then
    if grid[2] and grid[2][nx] then
      break
    else
      @create_next_state_move_in_corridor
    end
  end
end

@set_initial_state+=
@count_placed

@count_placed+=
state.placed = 0
for x=4,10,2 do
  for y=6,3,-1 do
    if loc[state.grid[y][x]] == x then
      state.placed = state.placed + 1
    else
      break
    end
  end
end

@variables+=
local best_energy

@add_completed+=
if not best_energy or cur.energy < best_energy then
  best_energy = cur.energy
end

@show_result+=
print(("%d energy"):format(best_energy))
