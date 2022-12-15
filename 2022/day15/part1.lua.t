##aoc
@variables+=
local test_input = [[
Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3
]]
local answer_test1 = 26

@parts+=
function part1(lines, istest)
	@local_variables
	@parse_input
	@foreach_sensor_calculate_where_beacon_cannot_be_on_line
	@compute_non_overlapping_beacon_on_check
	@calculate_not_possible_on_check
	return answer
end

@parse_input+=
for _, line in ipairs(lines) do
	local sx, sy = line:match("x=(%-?%d+), y=(%-?%d+):")
	sx = tonumber(sx)
	sy = tonumber(sy)
	local bx, by = line:match("x=(%-?%d+), y=(%-?%d+)$")
	bx = tonumber(bx)
	by = tonumber(by)
	table.insert(sensors, {sx, sy, bx, by})
end

@local_variables+=
local sensors = {}

@foreach_sensor_calculate_where_beacon_cannot_be_on_line+=
for _, s in ipairs(sensors) do
	local sx, sy, bx, by = unpack(s)

	@compute_range_on_check
	if range_len >= 0 then
		@merge_range_to_not_possible
	end
end

@local_variables+=
local range_borders = {}
local range_fill = { false }

@compute_range_on_check+=
local dist = math.abs(bx - sx) + math.abs(by - sy)
local range_len = dist
range_len = range_len - math.abs(check - sy)

@merge_range_to_not_possible+=
local r1 = sx - range_len
local r2 = sx + range_len

add_border(range_borders, range_fill, r1)
add_border(range_borders, range_fill, r2)

@functions+=
function add_border(borders, fill, x)
	local i = 1
	while i <= #borders and x > borders[i] do
		i = i + 1
	end

	if borders[i] == x then
		return
	end

	@if_leftmost_add_empty_fill
	@if_rightmost_add_empty_fill
	@otherwise_split_current_fill
end

@if_leftmost_add_empty_fill+=
if i == 1 then
	table.insert(borders, i, x)
	table.insert(fill, i, false)

@if_rightmost_add_empty_fill+=
elseif i == #borders+1 then
	borders[i] = x
	fill[i+1] = false

@otherwise_split_current_fill+=
else
	table.insert(borders, i, x)
	table.insert(fill, i, fill[i])
end

@merge_range_to_not_possible+=
fill_range(range_borders, range_fill, r1, r2)

@functions+=
function fill_range(borders, fill, r1, r2)
	local i  = 1
	@search_r1
	@search_r2
	@fill_from_r1_to_r2_in_fill
end

@search_r1+=
while i <= #borders and borders[i] < r1 do
	i = i + 1
end
assert(i <= #borders)
local r1i = i

@search_r2+=
while i <= #borders and borders[i] < r2 do
	i = i + 1
end
assert(i <= #borders)
local r2i = i

@fill_from_r1_to_r2_in_fill+=
for j=r1i+1,r2i do
	fill[j] = true
end

@local_variables+=
local check = istest and 10 or 2000000

@compute_non_overlapping_beacon_on_check+=
local beacons = {}
for _, s in ipairs(sensors) do
	local sx, sy, bx, by = unpack(s)
	if by == check then
		beacons[bx] = true
	end
end

local count_beacons = vim.tbl_count(beacons)

@functions+=
function range_count(borders, fill) 
	local sum = 0
	local i = 1
	while i <= #borders do
		local count = 1
		while fill[i+1] do
			count = count + borders[i+1] - borders[i]
			i = i + 1
		end
		i = i + 1
		sum = sum + count
	end
	return sum
end

@calculate_not_possible_on_check+=
local answer = range_count(range_borders, range_fill) - count_beacons
