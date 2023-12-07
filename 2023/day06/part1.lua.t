##aoc
@variables+=
local test_input = [[
Time:      7  15   30
Distance:  9  40  200
]]

local answer_test1 = 288

@parts+=
@define_functions
function part1(lines, istest)
	@local_variables
	@read_times
	@read_distances
	@foreach_race_find_score
	@multiply_scores
	return answer
end

@read_times+=
local times = vim.tbl_map(tonumber, vim.split(vim.split(lines[1], ":")[2], "%s+", {trimempty=true}))

@read_distances+=
local distances = vim.tbl_map(tonumber, vim.split(vim.split(lines[2], ":")[2], "%s+", {trimempty=true}))

@foreach_race_find_score+=
for i=1,#times do
	local T = times[i]
	local D = distances[i]
	@find_intersection_points
	@compute_score
end

@find_intersection_points+=
local A = -1
local B = T
local C = -D

local D = B^2-4*A*C

local x = {}
if D >= 0 then
	table.insert(x, (-B+math.sqrt(D))/(2*A))
	table.insert(x, (-B-math.sqrt(D))/(2*A))
end

@local_variables+=
local scores = {}

@compute_score+=
if #x > 0 then
	local xmin = math.max(math.min(x[1], x[2]), 0)
	local xmax = math.min(math.max(x[1], x[2]), T)

	if math.ceil(xmin) == xmin then
		xmin = xmin + 1
	else
		xmin = math.ceil(xmin)
	end

	if math.floor(xmax) == xmax then
		xmax = xmax - 1
	else
		xmax = math.floor(xmax)
	end

	table.insert(scores, math.max(xmax - xmin+1, 0))
else
	table.insert(scores, 0)
end

@multiply_scores+=
local answer = 1
for _, score in ipairs(scores) do
	answer = answer * score
end


