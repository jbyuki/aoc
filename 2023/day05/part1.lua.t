##aoc
@variables+=
local test_input = [[
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
]]

local answer_test1 = 35

@parts+=
function part1(lines, istest)
	@local_variables
	@parse_seeds
	@parse_maps
	@foreach_seed_find_location
	@get_minimum_location
	return answer
end

@parse_seeds+=
local seeds = vim.tbl_map(tonumber, vim.split(vim.split(lines[1], ":")[2], "%s+", {trimempty=true}))

@parse_maps+=
for i=2,#lines do
	if #vim.trim(lines[i]) > 0 then
		local line = lines[i]
		@if_map_title
		@otherwise_range
		end
	end
end

@local_variables+=
local maps = {}

@if_map_title+=
if line:match("map") then
	@parse_map_title
	@set_current_map

@parse_map_title+=
local from, to = line:match("(%a+)%-to%-(%a+)%s+map")

@local_variables+=
local current_map

@set_current_map+=
current_map = {from, to}

@otherwise_range+=
else
	@parse_range
	@set_range_in_map
	
@parse_range+=
local range = vim.tbl_map(tonumber, vim.split(line, "%s+", {trimempty=true}))

@set_range_in_map+=
if not maps[current_map[1]] then
	maps[current_map[1]] = {}
end

table.insert(maps[current_map[1]], {current_map[2], range})

@foreach_seed_find_location+=
for _, seed in ipairs(seeds) do
	local loc = "seed"
	local num = seed
	while true do
		@find_corresponding_map
	end
	@add_loc_to_loc_list
end

@find_corresponding_map+=
local found = false
if maps[loc] then
	for _, info in ipairs(maps[loc]) do
		local range = info[2]
		@if_in_range_map
	end

	if not found then
		@if_not_found_map_to_same
	end
end

if not found then
	break
end

@if_in_range_map+=
if num >= range[2] and num < range[2] + range[3] then
	num = (num - range[2]) + range[1]
	loc = info[1]
	found = true
	break
end

@if_not_found_map_to_same+=
loc = maps[loc][1][1]
found = true

@local_variables+=
local loc_list = {}

@add_loc_to_loc_list+=
table.insert(loc_list, num)

@get_minimum_location+=
local answer
for i=1,#loc_list do
	if not answer or answer > loc_list[i] then
		answer = loc_list[i]
	end
end

