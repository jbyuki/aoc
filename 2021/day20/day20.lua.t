##day20
@day20.lua=
@variables
@functions
@read_input
@parse_input
-- @display_grid
for i=1,50 do
  @pixel_for_empty
  @create_output
  @single_step
  @copy_output_to_input
  -- @display_grid
end
@count_lit_in_output
@show_result

@read_input+=
local lines = {}
for line in io.lines("input.txt") do
  table.insert(lines, line)
end

@variables+=
local rule = {}

@parse_input+=
rule = lines[1]

local grid = {}
local width = #lines[#lines]

for i=3,#lines do
  local row = {}
  for j=1,width do
    table.insert(row, lines[i]:sub(j,j))
  end
  table.insert(grid, row)
end

@functions+=
function bin2dec(row)
  local res = 0
  for i=1,#row do
    res = res * 2
    if row:sub(i,i) == "#" then
      res = res + 1
    end
  end
  return res
end

@variables+=
local offset = 1

@single_step+=
for y=1-offset,#grid+offset do
  @create_output_row
  for x=1-offset,width+offset do
    @get_3x3_pixel_grid
    @convert_kernel_to_index
    @place_kernel_output_in_output
  end
  @place_output_row
end

@get_3x3_pixel_grid+=
local block = ""
for dy=-1,1 do
  for dx=-1,1 do
    local pixel
    if grid[y+dy] then
      pixel = grid[y+dy][x+dx] or empty
    else
      pixel = grid[y+dy] or empty
    end
    block = block .. pixel
  end
end

@convert_kernel_to_index+=
local idx = bin2dec(block)

@create_output+=
local output = {}

@create_output_row+=
local output_row = {}

@place_kernel_output_in_output+=
local out = rule:sub(idx+1,idx+1)
table.insert(output_row, out)

@place_output_row+=
table.insert(output, output_row)

@copy_output_to_input+=
grid = output
width = #grid

@display_grid+=
print("--")
for _, row in ipairs(grid) do
  print(table.concat(row))
end

@count_lit_in_output+=
local count = 0
for _, row in ipairs(grid) do
  for i=1,#row do
    if row[i] == "#" then
      count = count + 1
    end
  end
end

@parse_input+=
print(width)

@show_result+=
print(count)
print(width)

@pixel_for_empty+=
local empty = "."
if rule:sub(1,1) == "#" and i%2 == 0 then
  empty = "#"
end
