##day22
@day22.lua=
@requires
@variables
@functions
@cuboid
@read_input
@parse_input
@create_initial_cuboid
@do_reboot_instruction
@measure_cuboid_volume
@show_result

@read_input+=
local lines = {}
for line in io.lines("input.txt") do
  table.insert(lines, line)
end

@parse_input+=
for _, line in ipairs(lines) do
  @parse_line
  -- @ignore_cubes_outside_init_region
  @create_instruction
end

@parse_line+=
local action, min_x, max_x, min_y, max_y, min_z, max_z = string.match(line, "^(%l+) x=(%-?%d+)%.%.(%-?%d+),y=(%-?%d+)%.%.(%-?%d+),z=(%-?%d+)%.%.(%-?%d+)")

min_x = tonumber(min_x)
max_x = tonumber(max_x)
min_y = tonumber(min_y)
max_y = tonumber(max_y)
min_z = tonumber(min_z)
max_z = tonumber(max_z)

@variables+=
local reboot = {}

@create_instruction+=
if min_x <= max_x and min_y <= max_y and min_z <= max_z then
  @transform_to_bignum
  local inst = {
    action, min_x, max_x, min_y, max_y, min_z, max_z
  }
  local c = cuboid.new(min_x, max_x, min_y, max_y, min_z, max_z)
  table.insert(reboot, { action, c })
end

@cuboid+=
local cuboid = {}

cuboid.new = function(min_x, max_x, min_y, max_y, min_z, max_z)
  local o = {}
  o.min_x = min_x
  o.max_x = max_x
  o.min_y = min_y
  o.max_y = max_y
  o.min_z = min_z
  o.max_z = max_z

  return setmetatable(o, { 
    __index = cuboid,
    @cuboid_metatable
  })
end


@cuboid_metatable+=
__tostring = function(self)
  return string.format("[%s %s] [%s %s] [%s %s]", self.min_x, self.max_x, self.min_y, self.max_y, self.min_z, self.max_z)
end,

@cuboid+=
function cuboid.intersect(self, other)
  @compute_x_interval_intersect
  @compute_y_interval_intersect
  @compute_z_interval_intersect

  @compute_cartesian_product_intersect
end

@functions+=
function my_min(x, y)
  if x < y then
    return x
  else
    return y
  end
end

function my_max(x, y)
  if x > y then
    return x
  else
    return y
  end
end

@compute_x_interval_intersect+=
local min_x = my_max(self.min_x, other.min_x)
local max_x = my_min(self.max_x, other.max_x)

if min_x > max_x then
  return
end

@compute_y_interval_intersect+=
local min_y = my_max(self.min_y, other.min_y)
local max_y = my_min(self.max_y, other.max_y)

if min_y > max_y then
  return
end

@compute_z_interval_intersect+=
local min_z = my_max(self.min_z, other.min_z)
local max_z = my_min(self.max_z, other.max_z)

if min_z > max_z then
  return
end

@compute_cartesian_product_intersect+=
return cuboid.new(
  min_x, max_x,
  min_y, max_y,
  min_z, max_z
)

@cuboid+=
function cuboid.substract(self, other) 
  local new_regions = {}
  @return_self_if_no_intersect

  @compute_regions_non_overlap_x
  @compute_regions_non_overlap_y
  @compute_regions_non_overlap_z

  return new_regions
end

function cuboid.volume(self)
  local range_x = my_abs(self.max_x - self.min_x)+1
  local range_y = my_abs(self.max_y - self.min_y)+1
  local range_z = my_abs(self.max_z - self.min_z)+1
  return range_x * range_y * range_z 
end

@variables+=
local zero = BigNum.new(0)

@functions+=
function my_abs(x)
  if x < zero then
    return -x
  else
    return x
  end
end

@compute_regions_non_overlap_x+=
local non_overlap_x = {}
non_overlap_x = non_overlap({self.min_x, self.max_x},{other.min_x, other.max_x})

@create_regions_non_overlap_x

@functions+=
function non_overlap(r1, r2)
  local min1, max1 = unpack(r1)
  local min2, max2 = unpack(r2)

  local intervals = {}
  @compute_interval_right_non_overlapping
  @compute_interval_left_non_overlapping

  return intervals
end

@compute_interval_left_non_overlapping+=
if min2 > min1 then
  table.insert(intervals, {
    min1, my_min(max1, min2-1)
  })
end

@compute_interval_right_non_overlapping+=
if max1 > max2 then
  table.insert(intervals, {
    my_max(min1, max2+1), max1
  })
end

@create_regions_non_overlap_x+=
for _, interval in ipairs(non_overlap_x) do
  table.insert(new_regions, cuboid.new(
    interval[1], interval[2],
    self.min_y, self.max_y,
    self.min_z, self.max_z
  ))
end


@compute_regions_non_overlap_y+=
local non_overlap_y = {}
non_overlap_y = non_overlap({self.min_y, self.max_y},{other.min_y, other.max_y})

@compute_overlap_x

if overlap_x then
  @create_regions_non_overlap_y
end

@compute_overlap_x+=
local overlap_x = overlap({self.min_x, self.max_x},{other.min_x, other.max_x})

@functions+=
function overlap(r1, r2)
  local min_both = my_max(r1[1], r2[1])
  local max_both = my_min(r1[2], r2[2])
  if min_both <= max_both then
    return { min_both, max_both }
  end
end

@create_regions_non_overlap_y+=
for _, interval in ipairs(non_overlap_y) do
  table.insert(new_regions, cuboid.new(
    overlap_x[1], overlap_x[2],
    interval[1], interval[2],
    self.min_z, self.max_z
  ))
end

@compute_regions_non_overlap_z+=
local non_overlap_z = {}
non_overlap_z = non_overlap({self.min_z, self.max_z},{other.min_z, other.max_z})

@compute_overlap_y

if overlap_x and overlap_y then
  @create_regions_non_overlap_z
end

@compute_overlap_y+=
local overlap_y = overlap({self.min_y, self.max_y},{other.min_y, other.max_y})

@create_regions_non_overlap_z+=
for _, interval in ipairs(non_overlap_z) do
  table.insert(new_regions, cuboid.new(
    overlap_x[1], overlap_x[2],
    overlap_y[1], overlap_y[2],
    interval[1], interval[2]
  ))
end

@functions+=
function sum_vol(cuboids)
  local sum = 0
  for _, c in ipairs(cuboids) do
    sum = sum + c:volume()
  end
  return sum
end

@create_initial_cuboid+=
local cuboids = {}
table.insert(cuboids, reboot[1][2])
table.remove(reboot, 1)

@do_reboot_instruction+=
for i=1,#reboot do
  local action, c = unpack(reboot[i])
  if action == "on" then
    @do_cuboid_addition
  elseif action == "off" then
    @do_cuboid_substraction
  end
end

@do_cuboid_addition+=
local added = { c }
for j=1,#cuboids do
  local new_added = {}

  for k=1,#added do
    vim.list_extend(new_added, added[k]:substract(cuboids[j]))
  end

  added = new_added
end

vim.list_extend(cuboids, added)

@do_cuboid_substraction+=
local new_cuboids = {}
for j=1,#cuboids do
  vim.list_extend(new_cuboids, cuboids[j]:substract(c))
end
cuboids = new_cuboids

@measure_cuboid_volume+=
local total_vol = sum_vol(cuboids)

@show_result+=
print(total_vol)

@ignore_cubes_outside_init_region+=
min_x = my_max(min_x, -50)
max_x = my_min(max_x, 50)

min_y = my_max(min_y, -50)
max_y = my_min(max_y, 50)

min_z = my_max(min_z, -50)
max_z = my_min(max_z, 50)

@transform_to_bignum+=
min_x = BigNum.new(min_x)
max_x = BigNum.new(max_x)
                        
min_y = BigNum.new(min_y)
max_y = BigNum.new(max_y)
                        
min_z = BigNum.new(min_z)
max_z = BigNum.new(max_z)

@requires+=
require"BigNum"

@return_self_if_no_intersect+=
local intersect = self:intersect(other)
if not intersect then
  table.insert(new_regions, self)
  return new_regions
end
