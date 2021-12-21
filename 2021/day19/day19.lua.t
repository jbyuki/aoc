##day19
@day19.lua=
@requires
@variables
@read_input
@make_map_with_scanner
@find_foreach_12_intersecting_beacons
@find_absolute_position_for_all_beacons
@make_list_of_all_beacons
@compute_biggest_manhattan_distance
@show_result

@read_input+=
for line in io.lines("test.txt") do
  @if_scanner_header_make_new
  @if_number_read_coord
end

@add_new_scanner_data

@variables+=
local scanners = {}

@read_input-=
local scanner = {}

@if_scanner_header_make_new+=
if line:match("^%-%-%-") then
  @add_new_scanner_data

@add_new_scanner_data+=
if #scanner > 0 then
  table.insert(scanners, scanner)
end
scanner = {}

@if_number_read_coord+=
elseif line:match("%d") then
  local x, y, z = line:match("(.+),(.+),(.+)")
  table.insert(scanner, Vec { tonumber(x),tonumber(y),tonumber(z) })
end

@variables+=
local beacons_map = {}

@make_map_with_scanner+=
for i=1,#scanners do
  beacons_map[i] = {}
  for _, pos in ipairs(scanners[i]) do
    local x, y, z = pos:unpack()

    beacons_map[i][x] = beacons_map[i][x] or {}
    beacons_map[i][x][y] = beacons_map[i][x][y] or {}
    beacons_map[i][x][y][z] = true
  end
end

@find_foreach_12_intersecting_beacons+=
for h=1,#scanners do
  for i=1,#scanners do
    if h ~= i then
      @create_rotated_pos_for_scanner
    end
  end
end

@create_rotated_pos_for_scanner+=
for dp1=1,3 do
  local rem = {1,2,3}
  table.remove(rem, dp1)
  for sp1=1,2 do
    local dir_p1 = Vec { 0, 0, 0 }
    if sp1 == 1 then
      dir_p1.rows[dp1][1] = 1
    else
      dir_p1.rows[dp1][1] = -1
    end
    
    @iterate_for_second_direction
  end
end

@iterate_for_second_direction+=
for dp2=1,2 do
  for sp2=1,2 do
    local dir_p2 = Vec { 0, 0, 0 }
    if sp2 == 1 then
      dir_p2.rows[rem[dp2]][1] = 1
    else
      dir_p2.rows[rem[dp2]][1] = -1
    end
    @find_third_direction_by_cross_product

    local rotated_pos = {}
    @create_rotated_pos
    @try_to_match_every_pair_of_beacons
  end
end

@find_third_direction_by_cross_product+=
local dir_p3 = dir_p1:cross(dir_p2)

@create_rotated_pos+=
local T = dir_p1:hconcat(dir_p2):hconcat(dir_p3)
for k=1,#scanners[i] do
  local pos = T * scanners[i][k]
  table.insert(rotated_pos, pos)
end

@try_to_match_every_pair_of_beacons+=
local matching = false
for j=1,#scanners[h] do
  for k=1,#rotated_pos do
    @compute_delta_for_two_beacons
    local num_match = 0
    @compute_num_of_matching_beacons
    
    if num_match >= 12 then
      @save_scanner_orientation
      matching = true
      break
    end
  end

  if matching then
    break
  end
end

@compute_delta_for_two_beacons+=
local delta = scanners[h][j] - rotated_pos[k] 
local dx, dy, dz = delta:unpack()


@compute_num_of_matching_beacons+=
for m=1,#rotated_pos do
  local p2 = rotated_pos[m]
  local x2, y2, z2 = p2:unpack()

  if beacons_map[h][x2+dx] and beacons_map[h][x2+dx][y2+dy] and beacons_map[h][x2+dx][y2+dy][z2+dz] then
    num_match = num_match + 1
  end
end

@variables+=
local orientation = {}

@save_scanner_orientation+=
orientation[h] = orientation[h] or {}
orientation[h][i] = {
  rotated_pos = rotated_pos,
  delta = delta,
  axis = T,
}

@requires+=
require "tangle.matrix"

@find_absolute_position_for_all_beacons+=
local abs_pos = { Vec { 0 , 0 , 0 } }

local axis = { Mat(3) }

while #scanners > vim.tbl_count(abs_pos) do
  for i=1,#scanners do
    if abs_pos[i] then
      for j=1,#scanners do
        if not abs_pos[j] then
          if orientation[i] and orientation[i][j] then
            @if_has_pos_add_abs_pos
          end
        end
      end
    end
  end
end
print("Done!")

@if_has_pos_add_abs_pos+=
local o = orientation[i][j]

axis[j] = axis[i] * o.axis
abs_pos[j] = abs_pos[i] + axis[i] * o.delta

@make_list_of_all_beacons+=
local all_bacons = {}
local beacon_count = 0
for i=1,#scanners do
  for n=1,#scanners[i] do
    local p = scanners[i][n]
    @transform_point
    @add_beacon_to_map
  end
end

@show_result+=
print("Answer " .. beacon_count)

@transform_point+=
local pos = abs_pos[i] + axis[i] * p

local x, y, z = pos:unpack()

@add_beacon_to_map+=
all_bacons[x] = all_bacons[x] or {}
all_bacons[x][y] = all_bacons[x][y] or {}
if not all_bacons[x][y][z] then
  all_bacons[x][y][z] = true
  beacon_count = beacon_count + 1 
end

@compute_biggest_manhattan_distance+=
local best
for i=1,#scanners do
  for j=1,#scanners do
    @compute_manhattan_distance
    @pick_biggest_distance
  end
end

@show_result+=
print("answer part 2 " .. best)

@compute_manhattan_distance+=
local dist = (abs_pos[i]-abs_pos[j]):l1_norm()

@pick_biggest_distance+=
if not best or best < dist then
  best = dist
end
