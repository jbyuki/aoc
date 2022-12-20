##aoc
@variables+=
local test_input = [[
Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
]]
local answer_test1 = 33
local answer_buy1 = {
	[3] = { 2 },
	[5] = { 2 },
	[7] = { 2 },
	[11] = { 3 },
	[12] = { 2 },
	[15] = { 3 },
	[18] = { 4 },
	[21] = { 4 },
}

@parts+=
function part1(lines, istest)
	@local_variables
	@parse_input
	@foreach_blueprint_find_quality_level
	-- @test_simulate
	return answer
end

@parse_input+=
for _, line in ipairs(lines) do
	@parse_blueprint
	@add_blueprint
end

@local_variables+=
local blueprints = {}

@parse_blueprint+=
local num = tonumber(line:match("(%d+):"))
local ore_robot = tonumber(line:match("Each ore robot costs (%d+) ore."))
local clay_robot = tonumber(line:match("Each clay robot costs (%d+) ore."))
local obs_robot = vim.tbl_map(tonumber, {line:match("Each obs.* robot costs (%d+) ore and (%d+) clay.")})
local geo_robot = vim.tbl_map(tonumber, {line:match("Each geo.* robot costs (%d+) ore and (%d+) obs.*")})

@compactify_blueprint

@add_blueprint+=
table.insert(blueprints, costs)

@compactify_blueprint+=
local costs = {}
for i=1,4 do
	costs[i] = {}
	for j=1,4 do
		costs[i][j] = 0
	end
end

costs[1][1] = ore_robot
costs[2][1] = clay_robot
costs[3][1] = obs_robot[1]
costs[3][2] = obs_robot[2]
costs[4][1] = geo_robot[1]
costs[4][3] = geo_robot[2]

@functions+=
function list_startswith(l1, l2) 
	if #l1 < #l2 then
		return false
	end
	for i=1,#l2 do
		if l1[i] ~= l2[i] then
			return false
		end
	end
	return true
end

@functions+=
function best_geodes(costs, total)
	local ores = { 0, 0, 0, 0 }
	local buy = { 4 }
	local waits = {}
	local tick = 0
	local robots = { 1, 0, 0, 0 }
	local best = 0

	while true do
		@compute_how_much_tick_until_can_buy
		@if_wait_after_end_figureout_geodes_at_end_and_go_to_next

		if can_buy then
			@advance_ticks_and_buy
			@goto_next_buy_additionnal
		end
	end
	return best
end

@compute_how_much_tick_until_can_buy+=
local next_buy = buy[#buy]
local can_buy = true
local wait = 0
for j=1,4 do
	if robots[j] == 0 then
		if costs[next_buy][j] > 0 then
			can_buy = false
			break
		end
	else
		wait = math.max(math.ceil((costs[next_buy][j] - ores[j])/robots[j]), wait)
	end
end

wait = wait + 1

@if_wait_after_end_figureout_geodes_at_end_and_go_to_next+=
if wait + tick >= total or not can_buy then
	local score = ores[4] + (total - tick)*robots[4]
	if score > best then
		print(score)
	end
	best = math.max(best, score)
	can_buy = false
	@go_to_next_failed_to_buy
end

@advance_ticks_and_buy+=
-- print("PUSH ", tick, next_buy, vim.inspect(ores), vim.inspect(robots), vim.inspect(buy))
for j=1,4 do
	ores[j] = ores[j] + wait*robots[j] - costs[next_buy][j]
end

tick = tick + wait
robots[next_buy] = robots[next_buy] + 1
table.insert(waits, wait)

@go_to_next_failed_to_buy+=
local still_continue = false
while #buy > 0 do
	local bought = buy[#buy]
	table.remove(buy)
	@buy_next_if_possible
	if #buy > 0 then
		@unbuy_last_one_and_go_backward
	end
end

if not still_continue then
	print("FINISHED")
	break
end

@unbuy_last_one_and_go_backward+=
bought = buy[#buy]
local waited = waits[#waits]
tick = tick - waited

robots[bought] = robots[bought] - 1

for j=1,4 do
	ores[j] = ores[j] - waited*robots[j] + costs[bought][j]
end

table.remove(waits)

-- print("POP ", tick, bought, vim.inspect(ores), vim.inspect(robots))

@buy_next_if_possible+=
if bought > 1 then
	table.insert(buy, bought-1)
	still_continue = true
	break
end

@goto_next_buy_additionnal+=
table.insert(buy, 4)

@foreach_blueprint_find_quality_level+=
local answer = 0
for id=1,#blueprints do
	local quality = best_geodes(blueprints[id], 24)
	print(id, quality)
	answer = answer + quality * id
end

@test_simulate+=
-- local buy = { 2, 2, 2, 3, 1, 3, 4, 2, 3, 4, 2, 4, 2 }
local buy = { 2, 2, 2, 3, 2, 3, 4, 4 }
local ores = { 0, 0, 0, 0 }
local robots = { 1, 0, 0, 0 }
local next_buy = 1
local costs = blueprints[1]

for i=1,24 do
	@check_if_possible_to_buy
	@mine_ores
	@buy_if_possible
	print(i, vim.inspect(ores))
end

print(vim.inspect(ores))

@mine_ores+=
for j=1,4 do
	ores[j] = ores[j] + robots[j]
end

@check_if_possible_to_buy+=
local new_robots = { 0, 0, 0, 0 }
while next_buy <= #buy do
	local can_buy = true
	for j=1,4 do
		if ores[j] < costs[buy[next_buy]][j] and costs[buy[next_buy]][j] > 0 then
			can_buy = false
			break
		end
	end
	if not can_buy then
		break
	end

	for j=1,4 do
		ores[j] = ores[j] - costs[buy[next_buy]][j]
	end

	print(i, buy[next_buy])
	new_robots[buy[next_buy]] = new_robots[buy[next_buy]] + 1
	next_buy = next_buy + 1
end

@buy_if_possible+=
for j=1,4 do
	robots[j] = robots[j] + new_robots[j]
end

