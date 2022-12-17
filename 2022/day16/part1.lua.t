##aoc
@variables+=
local test_input = [[
Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II
]]
local answer_test1 = 1651

@parts+=
function part1(lines, istest)
	@local_variables
	@parse_input
	@calculate_distance_from_one_to_another
	@compute_with_dp
	return answer
end

@parse_input+=
for _, line in ipairs(lines) do
	@parse_valve_name
	@parse_flow_rate
	@parse_valves_tunnel
	@add_valve
end

@local_variables+=
local tunnels = {}
local flow_rates = {}

@parse_valve_name+=
local name = line:match("Valve (%S+)")

@parse_flow_rate+=
local flow_rate = tonumber(line:match("=(%d+);"))

@parse_valves_tunnel+=
local rest = line:match("valves? (.+)$")
local passages = vim.split(rest, ",")
passages = vim.tbl_map(vim.trim, passages)

@add_valve+=
flow_rates[name] = flow_rate
tunnels[name] = passages

@calculate_distance_from_one_to_another+=
local keys = vim.tbl_keys(flow_rates)
local shortest = {}
for _, start in ipairs(keys) do
	shortest[start] = {}
	@do_bfs_on_cur
end

@do_bfs_on_cur+=
local open = { start }
local closed = {}
closed[start] = true

local dist = 0
while #open > 0 do
	local new_open = {}
	for i=1,#open do
		@add_to_shortest
		@explore_next
	end
	open = new_open
	dist = dist + 1
end

@add_to_shortest+=
local cur = open[i]
shortest[start][cur] = dist

@explore_next+=
for _, ne in ipairs(tunnels[cur]) do
	if not closed[ne] then
		table.insert(new_open, ne)
		closed[ne] = true
	end
end

@compute_with_dp+=
@get_non_zero
@compute_total_possible_flow
@explore_all_with_dp

@get_non_zero+=
local nonzeros = {}
for name, flow_rate in pairs(flow_rates) do
	if flow_rate ~= 0 then
		table.insert(nonzeros, name)
	end
end

@compute_total_possible_flow+=
local totalsum = 0
for _, flow_rate in pairs(flow_rates) do
	totalsum = totalsum + flow_rate
end

@functions+=
function explore(current, shortest, all, mask, numremaining, tick, totalsum, currentbest, flowed, flow, flow_rates) 
	if totalsum*tick + flowed < currentbest then
		return currentbest
	end

	@otherwise_pick_from_remaining
	@try_without_exploring
	return currentbest
end

@otherwise_pick_from_remaining+=
if numremaining > 0 then
	for i=1,#mask do
		if mask[i] then
			local dist = shortest[current][all[i]]
			mask[i] = false
			if tick-dist-1 > 0 then
				currentbest = explore(all[i], shortest, all, mask, numremaining-1, tick-dist-1, totalsum, currentbest, flowed + flow*(dist+1), flow+flow_rates[all[i]], flow_rates)
			end
			mask[i] = true
		end
	end
end

@try_without_exploring+=
if tick*flow + flowed > currentbest then
	return tick*flow + flowed
end

@explore_all_with_dp+=
local mask = {}
for i=1,#nonzeros do
	table.insert(mask, true)
end

local answer = explore("AA", shortest, nonzeros, mask, #nonzeros, 30, totalsum, 0, 0, 0, flow_rates)
