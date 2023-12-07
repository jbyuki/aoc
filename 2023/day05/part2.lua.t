##aoc
@variables+=
local answer_test2 = 46

@parts+=
@define_functions
function part2(lines, istest)
	@local_variables
	@parse_seeds
	@parse_maps
	@find_loc_foreach_seed_range
	@find_minimum_in_range
	return answer
end

@find_loc_foreach_seed_range+=
for i=1,#seeds,2 do
	local ranges = {{seeds[i], seeds[i+1]}}
	local loc = "seed"
	while true do
		@get_next_location
		local next_ranges = {}
		while true do
			local done = true
			for r, range in ipairs(ranges) do
				@pass_range_to_next_location
			end
			if done then
				break
			end
		end
		@add_remaining_ranges_to_next
		ranges = next_ranges 
		@go_to_next_loc
	end
	@save_final_ranges
end


@get_next_location+=
if not maps[loc] then
	break
end
local next_loc = maps[loc][1][1]

@go_to_next_loc+=
loc = next_loc

@pass_range_to_next_location+=
for _, entry in ipairs(maps[loc]) do
	local info = entry[2]
	@check_if_range_intersect
	if intersect then
		@split_range
		@for_each_split_distribute
		@update_new_ranges
		done = false
		break
	end
end

@check_if_range_intersect+=
local x1 = range[1]
local x2 = range[1]+range[2]-1

local y1 = info[2]
local y2 = info[2]+info[3]-1

local intersect = x1 <= y2 and y1 <= x2

@split_range+=
local splits = {}
@get_overlapped_range
@get_remaining_ranges

@get_overlapped_range+=
local s1 = math.max(x1,y1)
local s2 = math.min(x2,y2)
table.insert(splits, {s1,s2})

@get_remaining_ranges+=
if x1 < y1 then
	table.insert(splits, {x1, y1-1})
end

if x2 > y2 then
	table.insert(splits, {y2+1,x2})
end

@for_each_split_distribute+=
local has_moved = {}
for k=1,#splits do
	local split = splits[k]
	if split[1] <= y2 and y1 <= split[2] then
		@move_split_to_new_loc
		table.insert(has_moved, true)
	else
		table.insert(has_moved, false)
	end
end

@move_split_to_new_loc+=
local delta = info[1] - info[2]
split[1] = split[1] + delta
split[2] = split[2] + delta

@update_new_ranges+=
table.remove(ranges, r)
for k=1,#splits do
	if has_moved[k] then
		table.insert(next_ranges, {splits[k][1], splits[k][2]- splits[k][1]+1})
	else
		table.insert(ranges, {splits[k][1], splits[k][2]- splits[k][1]+1})
	end
end

@add_remaining_ranges_to_next+=
for _, range in ipairs(ranges) do
	table.insert(next_ranges, range)
end

@local_variables+=
local final_ranges = {}

@save_final_ranges+=
for _, range in ipairs(ranges) do
	if range[2] > 0 then
		table.insert(final_ranges, range)
	end
end

@find_minimum_in_range+=
local answer
for _, range in ipairs(final_ranges) do
	if not answer or answer > range[1] then
		answer = range[1]
	end
end

