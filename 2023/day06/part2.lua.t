##aoc
@variables+=
local answer_test2 = 71503

@parts+=
@define_functions
function part2(lines, istest)
	@local_variables
	@read_times
	@read_distances
	@concatenate_times_and_distances
	@foreach_race_find_score
	@multiply_scores
	return answer
end

@concatenate_times_and_distances+=
local res_time = ""
for _, time in ipairs(times) do
	res_time = res_time .. tostring(time)
end
times = { tonumber(res_time) }

local res_distance = ""
for _, dist in ipairs(distances) do
	res_distance = res_distance .. tostring(dist)
end
distances = { tonumber(res_distance) }

