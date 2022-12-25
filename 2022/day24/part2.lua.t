##aoc
@variables+=
local answer_test2 = 54

@parts+=
function part2(lines, istest)
	@local_variables
	@parse_input
	@find_grid_size
	@init_states
	@do_bfs_part2
	return answer
end


@do_bfs_part2+=
local minute = 1
while true do
	@blizzard_position_for_this_round
	-- @draw_blizzard_map
	@move_to_all_possible_squares
	@check_if_one_reached_goal_part2
	minute = minute + 1
end

@do_bfs_part2-=
local pos = { 1, 2 }
local open = { pos }


@do_bfs_part2-=
local next_goal = {
	{ N, M-1 },
	{ 1, 2 },
	{ N, M-1 }
}

local goal_idx = 1

@check_if_one_reached_goal_part2+=
if close[next_goal[goal_idx][1]] and close[next_goal[goal_idx][1]][next_goal[goal_idx][2]] then
	if next_goal[goal_idx+1] then
		print("goal")
		open = { next_goal[goal_idx] }
		goal_idx = goal_idx+1
	else
		answer = minute
		break
	end
end
