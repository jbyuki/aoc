##day13
@day13=
@variables
@functions
@read_input
@create_empty_grid
@fill_initial_grid
@do_first_fold
@do_all_folds
-- @count_non_empty
@show_result

@read_input+=
for line in io.lines("input.txt") do
  if line:match("^%d") then
    @read_coord
    @adjust_max_coord
  elseif line:match("^f") then
    @parse_fold
  end
end

@variables+=
local coords = {}

@read_coord+=
local x, y = line:match("(%d+),(%d+)")
x = tonumber(x)
y = tonumber(y)
table.insert(coords, { x, y })

@variables+=
local max_x = 0
local max_y = 0

@adjust_max_coord+=
max_x = math.max(x+1, max_x)
max_y = math.max(y+1, max_y)

@variables+=
local folds = {}

@parse_fold+=
local dir, val = line:match("(%l)=(%d+)")
table.insert(folds, { dir, tonumber(val) })

@create_empty_grid+=
local grid = {}
for y=1,max_y do
  local row = {}
  for x=1,max_x do
    table.insert(row, ".")
  end
  table.insert(grid, row)
end

@functions+=
function do_fold(old_grid, fold) 
  local dir, val = unpack(fold)
  local h = #old_grid
  local w = #(old_grid[1])

  if dir == "x" then
    @create_empty_grid_x
    @fill_first_half_x
    @fill_second_half_x
    return grid
  elseif dir == "y" then
    @create_empty_grid_y
    @fill_first_half_y
    @fill_second_half_y
    return grid
  end
end

@create_empty_grid_x+=
local max_x = (w-1)/2
local max_y = h
@create_empty_grid

@fill_first_half_x+=
for y=1,h do
  for x=1,max_x do
    if old_grid[y][x] == "#" then
      grid[y][x] = "#"
    end
  end
end

@fill_second_half_x+=
for y=1,h do
  for x=1,max_x do
    if old_grid[y][x+max_x+1] == "#" then
      grid[y][max_x - x + 1] = "#"
    end
  end
end

@fill_initial_grid+=
for _, coord in ipairs(coords) do
  local x, y = unpack(coord)
  grid[y+1][x+1] = "#"
end

@create_empty_grid_y+=
local max_y = (h-1)/2
local max_x = w
@create_empty_grid

@fill_first_half_y+=
for y=1,max_y do
  for x=1,w do
    if old_grid[y][x] == "#" then
      grid[y][x] = "#"
    end
  end
end

@fill_second_half_y+=
for y=1,max_y do
  for x=1,w do
    if old_grid[y+max_y+1][x] == "#" then
      grid[max_y - y + 1][x] = "#"
    end
  end
end

-- @do_first_fold+=
-- grid = do_fold(grid, folds[1])

@functions+=
function show_grid(grid)
  for _, row in ipairs(grid) do
    print(table.concat(row))
  end
end

@count_non_empty+=
local answer = 0
for y=1,#grid do
  for x=1,#grid[y] do
    if grid[y][x] == "#" then
      answer = answer + 1
    end
  end
end

@show_result+=
-- print(answer)

@do_all_folds+=
for _, fold in ipairs(folds) do
  grid = do_fold(grid, fold)
end

@show_result+=
show_grid(grid)
