@*=
@requires
@variables
@functions
@read_input
-- @read_test
@parse_input
@process_input
@process_input2
@display_result

@read_input+=
local lines = {}

for line in io.lines("input.txt") do
	table.insert(lines, line)
end

@read_test+=
local lines = {}

for line in io.lines("test.txt") do
	table.insert(lines, line)
end

@process_input+=
local changed = true
local curstate = lines
local limit = 5
local ans = 0
while changed do
	changed = false

	@simulate_one_step
	-- @display_state
	curstate = nextstate
	ans = ans + 1
end

@simulate_one_step+=
local nextstate = {}
local w, h = string.len(curstate[1]), #curstate

for y=1,h do
	local nextrow = ""
	for x=1,w do
		local c = string.sub(curstate[y], x, x)
		@if_floor_just_put_in_next
		@if_seat_do_process
	end
	table.insert(nextstate, nextrow)
end

@if_floor_just_put_in_next+=
if c == "." then
	nextrow = nextrow .. "."

@if_seat_do_process+=
else
	local neigh = 0
	-- @compute_number_of_neighbours
	@compute_number_of_neighbours_line_of_sight
	@determine_next_state_from_neighbour_count
end

@compute_number_of_neighbours+=
local neigh = 0
for dy=-1,1 do
	for dx=-1,1 do
		@skip_if_out_of_bound
		@skip_if_same_seat
		@otherwise_count
	end
end

@skip_if_out_of_bound+=
if x+dx < 1 or x+dx > w or y+dy < 1 or y+dy > h then

@skip_if_same_seat+=
elseif dx == 0 and dy == 0 then

@otherwise_count+=
else 
	local c = string.sub(curstate[y+dy], x+dx, x+dx)
	if c == "#" then neigh = neigh + 1 end
end

@determine_next_state_from_neighbour_count+=
if neigh == 0 then
	nextrow = nextrow .. "#"
	if c ~= "#" then changed = true end
elseif neigh >= 5 then
	nextrow = nextrow .. "L"
	if c ~= "L" then changed = true end
else
	nextrow = nextrow .. c
end

@display_state+=
print("----")
for _, line in ipairs(nextstate) do
	print(line)
end

@process_input+=
local occupied = 0
local w, h = string.len(curstate[1]), #curstate
for y=1,h do
	for x=1,w do
		local c = string.sub(curstate[y], x, x)
		if c == "#" then occupied = occupied + 1 end
	end
end

@compute_number_of_neighbours_line_of_sight+=
for dy=-1,1 do
	for dx=-1,1 do
		@skip_if_no_displacement
		@go_until_seat_reached_or_out_of_bounds
	end
end

@display_result+=
print("occupied " .. occupied)

@skip_if_no_displacement+=
if dx == 0 and dy == 0 then


@go_until_seat_reached_or_out_of_bounds+=
else
	local px, py = x+dx, y+dy
	while px >= 1 and py >= 1 and px <= w and py <= h do 
		@if_seat_block_and_check
		px, py = px+dx, py+dy
	end
end

@if_seat_block_and_check+=
local c = string.sub(curstate[py], px, px)
if c == "L" then break end
if c == "#" then neigh = neigh + 1 break end
