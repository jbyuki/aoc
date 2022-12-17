##aoc
@variables+=
local answer_test2 = 1707

@parts+=
function part2(lines, istest)
	@local_variables
	@parse_input
	@calculate_distance_from_one_to_another
	@get_non_zero
	@compute_total_possible_flow
	@do_dp_with_elephant
	return answer
end

@functions+=
function explore_with(me_current, elephant_current, me_tick, elephant_tick, numremaining, mask, flowed, me_flow, elephant_flow, currentbest, depth) 
	if flowed + math.max(me_tick, elephant_tick) * total_flow < currentbest then
		return currentbest
	end

	if numremaining > 0 then
		@try_to_pick_every_possibility
	end

	@try_to_not_pick_anything
	return currentbest
end

@try_to_pick_every_possibility+=
for i=1,#mask do
	if depth == 0 then
		print(i)
	end
	if mask[i] then
		mask[i] = false
		dist = shortest[me_current][all[i]]
		if dist and me_tick - (dist+1) > 0 then
			currentbest = explore_with(all[i], elephant_current, me_tick - (dist+1), elephant_tick, numremaining-1, mask, flowed + me_flow * (dist+1), me_flow + flow_rates[all[i]], elephant_flow, currentbest, depth+1)
		end

		if depth > 0 then
			dist = shortest[elephant_current][all[i]]
			if dist and elephant_tick - (dist+1) > 0 then
				currentbest = explore_with(me_current, all[i], me_tick, elephant_tick - (dist+1), numremaining-1, mask, flowed + elephant_flow * (dist+1), me_flow, elephant_flow + flow_rates[all[i]], currentbest, depth+1)
			end
		end
		mask[i] = true
	end
end

@try_to_not_pick_anything+=
if flowed + elephant_tick*elephant_flow +  me_tick*me_flow > currentbest then
	return flowed + elephant_tick*elephant_flow +  me_tick*me_flow
end

@do_dp_with_elephant+=
local mask = {}
for i=1,#all do
	table.insert(mask, true)
end

local answer = explore_with("AA", "AA", 26, 26, #mask, mask, 0, 0, 0, 0, 0)
