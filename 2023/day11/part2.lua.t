##aoc
@variables+=
-- local test_input2 = [[
-- ]]

@variables+=
local answer_test2 = 8410

@parts+=
@define_functions
function part2(lines, istest)
	@local_variables
	@find_location_of_galaxies
	@find_empty_rows
	@find_empty_cols
	@expand_location_galaxies_million
	@compute_pairwise_distances
	return answer
end

@expand_location_galaxies_million+=
local expand = istest and 100 or 1000000

for i=1,#locs do
	local r,c = unpack(locs[i])
	@increment_row_million
	@increment_col_million
	locs[i] = {r,c}
end

@increment_row_million+=
local inc = 0
for _,rr in ipairs(empty_rows) do
	if rr < r then
		inc = inc + (expand-1)
	else
		break
	end
end
r = r + inc

@increment_col_million+=
local inc = 0
for _,cc in ipairs(empty_cols) do
	if cc < c then
		inc = inc + (expand-1)
	else
		break
	end
end
c = c + inc
