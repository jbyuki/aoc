##aoc
@variables+=
local test_input1 = [[
2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533
]]
local answer_test1 = 102

@parts+=
@define_functions
function part1(lines, istest)
	local answer = 0
	@local_variables
	@do_djisktra
	return answer
end

@do_djisktra+=
local open = {}
local best = {}

local rows = #lines
local cols = #lines[1]

@pack_state
@unpack_state

table.insert(open, { pack_state(1,1,0,0), 0 })

while #open > 0 do
	@compute_minimum_in_open

	local state, score = unpack(open[min_dist])
	table.remove(open, min_dist)

	local y, x, dir, mag = unpack_state(state)
	local neigh = {}

	@add_left
	@add_right
	@add_up
	@add_down

	@add_neighbors
end

@pack_state+=
local pack_state = function(y,x,dir,mag)
	assert(y >= 1 and y <= rows)
	assert(x >= 1 and x <= cols)
	assert(dir >= 0 and dir <= 3)
	assert(mag >= 0 and mag <= 3)
	return y * (cols+1) * 16 + x * 16 + dir * 4 + mag
end

@unpack_state+=
local unpack_state = function(state)
	local y = math.floor(state / ((cols+1) * 16))
	local x = math.floor(state / 16) % (cols+1)
	local dir = math.floor(state / 4) % 4
	local mag = state % 4
	return y,x,dir,mag
end

@local_variables+=
local LEFT = 0
local RIGHT = 1
local UP = 2
local DOWN = 3

@add_left+=
if x > 1 and not (dir == RIGHT and mag > 0) and not (dir == LEFT and mag == 3) then
	local new_dir = LEFT
	if dir == LEFT then
		new_mag = mag + 1
	else
		new_mag = 1
	end

	table.insert(neigh, {x-1, y, new_dir, new_mag, score + tonumber(lines[y]:sub(x-1,x-1))})
end

@add_right+=
if x < cols and not (dir == LEFT and mag > 0) and not (dir == RIGHT and mag == 3) then
	local new_dir = RIGHT
	if dir == RIGHT then
		new_mag = mag + 1
	else
		new_mag = 1
	end

	table.insert(neigh, {x+1, y, new_dir, new_mag, score + tonumber(lines[y]:sub(x+1,x+1))})
end

@add_up+=
if y > 1 and not (dir == DOWN and mag > 0) and not (dir == UP and mag == 3) then
	local new_dir = UP
	if dir == UP then
		new_mag = mag + 1
	else
		new_mag = 1
	end

	table.insert(neigh, {x, y-1, new_dir, new_mag, score + tonumber(lines[y-1]:sub(x,x))})
end

@add_down+=
if y < rows and not (dir == UP and mag > 0) and not (dir == DOWN and mag == 3) then
	local new_dir = DOWN
	if dir == DOWN then
		new_mag = mag + 1
	else
		new_mag = 1
	end

	table.insert(neigh, {x, y+1, new_dir, new_mag, score + tonumber(lines[y+1]:sub(x,x))})
end

@add_neighbors+=
local finished = false
for _, n in ipairs(neigh) do
	local nx, ny, ndir, nmag, nscore = unpack(n)
	local nstate = pack_state(ny, nx, ndir, nmag)
	@check_if_finished
	if not best[nstate] or best[nstate] > nscore then
		best[nstate] = nscore
		table.insert(open, {nstate, nscore})
	end
end

if finished then
	break
end

@compute_minimum_in_open+=
local min_dist = 1
local min_score = open[min_dist][2]
for i=1,#open do
	if open[i][2] < min_score then
		min_dist = i
		min_score = open[i][2]
	end
end

@check_if_finished+=
if nx == cols and ny == rows then
	answer = nscore
	finished = true
end

