##day19
@day19.lua=
@variables
@read_input
@make_map_with_scanner
@find_foreach_12_intersecting_beacons
@find_absolute_position_for_all_beacons
@make_list_of_all_beacons
@compute_biggest_manhattan_distance
@show_result

@read_input+=
for line in io.lines("input.txt") do
  @if_scanner_header_make_new
  @if_number_read_coord
end

if vim.tbl_count(scanner) > 0 then
  table.insert(scanners, scanner)
  scanner = {}
end

@variables+=
local scanners = {}

@read_input-=
local scanner = {}

@if_scanner_header_make_new+=
if line:match("^%-%-%-") then
  local num = line:match("scanner (%d+)")
  if vim.tbl_count(scanner) > 0 then
    table.insert(scanners, scanner)
  end
  scanner = {}

@if_number_read_coord+=
elseif line:match("%d") then
  local x, y, z = line:match("(.+),(.+),(.+)")
  table.insert(scanner, {
    tonumber(x),tonumber(y),tonumber(z)
  })
end

@variables+=
local beacons_map = {}

@make_map_with_scanner+=
for i=1,#scanners do
  beacons_map[i] = {}
  for _, pos in ipairs(scanners[i]) do
    local x, y, z = unpack(pos)

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
    local dir_p1 = { 0, 0, 0 }
    if sp1 == 1 then
      dir_p1[dp1] = 1
    else
      dir_p1[dp1] = -1
    end
    
    @iterate_for_second_direction
  end
end

@iterate_for_second_direction+=
for dp2=1,2 do
  for sp2=1,2 do
    local dir_p2 = { 0, 0, 0 }
    if sp2 == 1 then
      dir_p2[rem[dp2]] = 1
    else
      dir_p2[rem[dp2]] = -1
    end
    @find_third_direction_by_cross_product
    @find_index_of_dirs

    local rotated_pos = {}
    @create_rotated_pos
    @try_to_match_every_pair_of_beacons
  end
end

@find_third_direction_by_cross_product+=
local dir_p3 = {}
dir_p3[1] = dir_p1[2]*dir_p2[3] - dir_p1[3]*dir_p2[2]
dir_p3[2] = dir_p1[3]*dir_p2[1] - dir_p1[1]*dir_p2[3]
dir_p3[3] = dir_p1[1]*dir_p2[2] - dir_p1[2]*dir_p2[1]

@find_index_of_dirs+=
local ip1, ip2, ip3
for m=1,3 do if dir_p1[m] ~= 0 then ip1 = m break end end
for m=1,3 do if dir_p2[m] ~= 0 then ip2 = m break end end
for m=1,3 do if dir_p3[m] ~= 0 then ip3 = m break end end

@create_rotated_pos+=
for k=1,#scanners[i] do
  local x, y, z = unpack(scanners[i][k])

  local pos = {}
  pos[ip1] = dir_p1[ip1]*x
  pos[ip2] = dir_p2[ip2]*y
  pos[ip3] = dir_p3[ip3]*z

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
local x1, y1, z1 = unpack(scanners[h][j])
local x2, y2, z2 = unpack(rotated_pos[k])

local dx, dy, dz = x1 - x2, y1 - y2, z1 - z2

@compute_num_of_matching_beacons+=
for m=1,#rotated_pos do
  local x2, y2, z2 = unpack(rotated_pos[m])

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
  delta = {dx, dy, dz},
  axis = { dir_p1, dir_p2,  dir_p3 },
  ip1 = ip1,
  ip2 = ip2,
  ip3 = ip3,
}


@find_absolute_position_for_all_beacons+=
local abs_pos = {
  { 0, 0, 0 }
}

local axis = {
  { { 1, 0, 0 }, { 0, 1, 0 }, { 0, 0, 1 } },
}

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
local ax = axis[i]
local pos = { abs_pos[i][1], abs_pos[i][2], abs_pos[i][3] }
for m=1,3 do
  for n=1,3 do
    pos[n] = pos[n] + o.delta[m] * axis[i][m][n]
  end
end

axis[j] = {
  {0, 0, 0},
  {0, 0, 0},
  {0, 0, 0}
}


for n=1,3 do
  for m=1,3 do
    for k=1,3 do
      axis[j][n][m] = axis[j][n][m] + axis[i][k][m] * o.axis[n][k]
    end
  end
end

abs_pos[j] = pos

@make_list_of_all_beacons+=
local all_bacons = {}
local beacon_count = 0
for i=1,#scanners do
  for n=1,#scanners[i] do
    local delta = scanners[i][n]
    @transform_point
    @add_beacon_to_map
  end
end

@show_result+=
print("Answer " .. beacon_count)

@transform_point+=
local pos = { abs_pos[i][1], abs_pos[i][2], abs_pos[i][3] }
for m=1,3 do
  for n=1,3 do
    pos[n] = pos[n] + delta[m] * axis[i][m][n]
  end
end

@add_beacon_to_map+=
all_bacons[pos[1]] = all_bacons[pos[1]] or {}
all_bacons[pos[1]][pos[2]] = all_bacons[pos[1]][pos[2]] or {}
if not all_bacons[pos[1]][pos[2]][pos[3]] then
  all_bacons[pos[1]][pos[2]][pos[3]] = true
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
local dist = 0
dist = dist + math.abs(abs_pos[i][1]-abs_pos[j][1])
dist = dist + math.abs(abs_pos[i][2]-abs_pos[j][2])
dist = dist + math.abs(abs_pos[i][3]-abs_pos[j][3])

@pick_biggest_distance+=
if not best or best < dist then
  best = dist
end
