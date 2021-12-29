##day23
@day23.lua=
@variables
@functions
@init_empty_states
@parse_input
@set_initial_state
@explore_all_possibilities
@show_result

@variables+=
local initial = { grid = {}, history = {}, energy = 0 }

@init_empty_states+=
for i=1,5 do
  table.insert(initial.grid, {})
end

@parse_input+=
local y = 1
for line in io.lines("test.txt") do
  for x=1,#line do
    local c = line:sub(x,x)
    @if_letter_add_to_states
  end
  y = y + 1
end

@if_letter_add_to_states+=
if c:match("%u") then
  initial.grid[y][x] = c
end

@explore_all_possibilities+=
local open = { initial }
local it = 1
while #open > 0 and it < 1000000 do
  @get_last_on_open
  -- if not best_energy or cur.energy < best_energy then
    -- @show_state
    @compute_code_and_check_memoization
    if m then
      @compute_from_memoization
    else
      @add_all_possibilities_to_open
      @if_all_placed_add_to_finish
    end
  -- end
  it = it + 1
end
print(#open)

@get_last_on_open+=
local cur = open[#open]
table.remove(open)
local grid = cur.grid

@add_all_possibilities_to_open+=
local not_placed = 0
for y, _ in pairs(grid) do
  for x, c in pairs(grid[y]) do
    @check_if_already_placed
    if not placed then
      not_placed = not_placed + 1
      @check_if_in_corridor
      if corridor then
        @if_possible_move_into_place
      else
        @otherwise_check_if_moveable_into_corridor
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

@check_if_already_placed+=
local placed = false
if x == loc[c] then
  if y == 4 then
    placed = true
  elseif y == 3 and grid[y+1][x] == c then
    placed = true
  end
end

@check_if_in_corridor+=
local corridor = y == 2

@if_possible_move_into_place+=
local num = math.abs(loc[c] - x)
local dx = (loc[c] - x)/num

local free = true
local cx = x
for i=1,num do
  if grid[2][cx+dx*i] then
    free = false
    break
  end
end

if free and not grid[3][loc[c]] then
  for ny=4,5 do
    if ny == 5 or grid[ny][loc[c]] then
      @check_that_below_correct_amphipodes
      if stacked then
        @move_amphipod_into_place_above
      end
    end
  end
end

@check_that_below_correct_amphipodes+=
local stacked = true
for nny=ny,4 do
  if grid[nny][loc[c]] ~= c then
    stacked = false
  end
end

@variables+=
local cost = {}
cost["A"] = 1
cost["B"] = 10
cost["C"] = 100
cost["D"] = 1000

@move_amphipod_into_place_above+=
local n = vim.deepcopy(cur)
n.energy = n.energy + (num+(ny-3))*cost[c]
n.grid[y][x] = nil
n.grid[ny-1][loc[c]] = c
@add_current_to_history
table.insert(open, n)

@otherwise_check_if_moveable_into_corridor+=
local moveable = true
@check_that_free_above

if moveable then
  @move_into_all_corridor_possibilities_right
  @move_into_all_corridor_possibilities_left
end

@check_that_free_above+=
for ny=y-1,2,-1 do
  if grid[ny][x] then
    moveable = false
  end
end

@variables+=
local room_entry = {}
room_entry[4] = true
room_entry[6] = true
room_entry[8] = true
room_entry[10] = true

@move_into_all_corridor_possibilities_right+=
for cx=x+1,12 do
  if not room_entry[cx] and grid[2][cx] then
    break
  end

  @create_state_move_corridor
end

@create_state_move_corridor+=
local n = vim.deepcopy(cur)
n.energy = n.energy + (math.abs(cx-x) + (y-2)) * cost[c]
n.grid[y][x] = nil
n.grid[2][cx] = c
@add_current_to_history
table.insert(open, n)

@move_into_all_corridor_possibilities_left+=
for cx=x-1,2,-1 do
  if not room_entry[cx] and grid[2][cx] then
    break
  end

  @create_state_move_corridor
end

@if_all_placed_add_to_finish+=
if not_placed == 0 then
  @update_memoization
  @update_best
end

@update_best+=
if not best_energy or best_energy > cur.energy then
  best_energy = cur.energy
end

@variables+=
local best_energy

@show_result+=
print(vim.inspect(best_energy))

@functions+=
function show_grid(grid)
  for y=1,5 do
    local line = ""
    for x=1,13 do
      if grid[y] and grid[y][x] then
        line = line .. grid[y][x]
      else
        line = line .. "."
      end
    end
    print(line)
  end
end

@show_state+=
print("---")
show_grid(cur.grid)

@variables+=
local code = {}
code["A"] = 1
code["B"] = 2
code["C"] = 3
code["D"] = 4

@functions+=
function get_code(grid)
  local code1 = 0

  for _,x in ipairs({4,6,8,10}) do
    for y=3,4 do
      code1 = code1 * 5
      if grid[y][x] then
        code1 = code1 + code[grid[y][x]]
      end
    end
  end

  local code2 = 0

  for x=2,12 do
    code2 = code2 * 5
    if grid[2][x] then
      code2 = code2 + code[grid[2][x]]
    end
  end
  return {code1, code2}
end

@variables+=
local memo = {}

@compute_code_and_check_memoization+=
local code = get_code(cur.grid)
local m = memo[code[1]] and memo[code[1]][code[2]]

@update_memoization+=
for _, h in ipairs(cur.history) do
  local old_code, old_energy = unpack(h)
  local delta_energy = cur.energy - old_energy
  if not memo[old_code[1]] or not memo[old_code[1]][old_code[2]] or memo[old_code[1]][old_code[2]] > delta_energy then
    memo[old_code[1]] = memo[old_code[1]] or {}
    memo[old_code[1]][old_code[2]] = delta_energy
  end
end

@compute_from_memoization+=
local end_energy = m + cur.energy
for _, h in ipairs(cur.history) do
  local old_code, old_energy = unpack(h)
  local delta_energy = end_energy - old_energy
  if not memo[old_code[1]] or not memo[old_code[1]][old_code[2]] or memo[old_code[1]][old_code[2]] > delta_energy then
    memo[old_code[1]] = memo[old_code[1]] or {}
    memo[old_code[1]][old_code[2]] = delta_energy
  end
end

@update_best_energy_memoization

@add_current_to_history+=
table.insert(n.history, { code, cur.energy })

@update_best_energy_memoization+=
if not best_energy or end_energy < best_energy then
  best_energy = end_energy
end
