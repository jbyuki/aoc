##aoc
@variables+=
-- local test_input2 = [[
-- ]]

@variables+=
local answer_test2 = 94

@parts+=
@define_functions
function part2(lines, istest)
	@local_variables
	@do_djisktra_part2
	return answer
end

@do_djisktra_part2+=
local open = {}
local best = {}

local rows = #lines
local cols = #lines[1]

@pack_state_part2
@unpack_state_part2

@initial_open

while #open > 0 do
	@compute_minimum_in_open

	local state, score = unpack(open[min_dist])
	table.remove(open, min_dist)

	local y, x, dir, mag = unpack_state_part2(state)
	local neigh = {}

	@add_left_part2
	@add_right_part2
	@add_up_part2
	@add_down_part2

	@add_neighbors_part2
end

@pack_state_part2+=
local pack_state_part2 = function(y,x,dir,mag)
	assert(y >= 1 and y <= rows)
	assert(x >= 1 and x <= cols)
	assert(dir >= 0 and dir <= 3)
	assert(mag >= 0 and mag <= 10)
	return y * (cols+1) * 44 + x * 44 + dir * 11 + mag
end

@unpack_state_part2+=
local unpack_state_part2 = function(state)
	local y = math.floor(state / ((cols+1) * 44))
	local x = math.floor(state / 44) % (cols+1)
	local dir = math.floor(state / 11) % 4
	local mag = state % 11
	return y,x,dir,mag
end

@initial_open+=
table.insert(open, { pack_state_part2(1,1,RIGHT,0), 0 })
table.insert(open, { pack_state_part2(1,1,DOWN,0), 0 })

@add_left_part2+=
if x > 1 and not (dir == RIGHT and mag > 0) and ((dir ~= LEFT and mag >= 4) or (dir == LEFT)) and not (dir == LEFT and mag == 10) then
	local new_dir = LEFT
	if dir == LEFT then
		new_mag = mag + 1
	else
		new_mag = 1
	end

	table.insert(neigh, {x-1, y, new_dir, new_mag, score + tonumber(lines[y]:sub(x-1,x-1))})
end

@add_right_part2+=
if x < cols and not (dir == LEFT and mag > 0) and ((dir ~= RIGHT and mag >= 4) or (dir == RIGHT)) and not (dir == RIGHT and mag == 10) then
	local new_dir = RIGHT
	if dir == RIGHT then
		new_mag = mag + 1
	else
		new_mag = 1
	end

	table.insert(neigh, {x+1, y, new_dir, new_mag, score + tonumber(lines[y]:sub(x+1,x+1))})
end

@add_up_part2+=
if y > 1 and not (dir == DOWN and mag > 0) and ((dir ~= UP and mag >= 4) or (dir == UP)) and not (dir == UP and mag == 10) then
	local new_dir = UP
	if dir == UP then
		new_mag = mag + 1
	else
		new_mag = 1
	end

	table.insert(neigh, {x, y-1, new_dir, new_mag, score + tonumber(lines[y-1]:sub(x,x))})
end

@add_down_part2+=
if y < rows and not (dir == UP and mag > 0) and ((dir ~= DOWN and mag >= 4) or (dir == DOWN)) and not (dir == DOWN and mag == 10) then
	local new_dir = DOWN
	if dir == DOWN then
		new_mag = mag + 1
	else
		new_mag = 1
	end

	table.insert(neigh, {x, y+1, new_dir, new_mag, score + tonumber(lines[y+1]:sub(x,x))})
end

@add_neighbors_part2+=
local finished = false
for _, n in ipairs(neigh) do
	local nx, ny, ndir, nmag, nscore = unpack(n)
	local nstate = pack_state_part2(ny, nx, ndir, nmag)
	@check_if_finished_part2
	if not best[nstate] or best[nstate] > nscore then
		best[nstate] = nscore
		table.insert(open, {nstate, nscore})
	end
end

if finished then
	break
end

@check_if_finished_part2+=
if nx == cols and ny == rows and mag >= 4 then
	answer = nscore
	finished = true
end

