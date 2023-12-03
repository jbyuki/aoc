##aoc
@variables+=
local test_input = [[
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
]]

local answer_test1 = 4361

@parts+=
function part1(lines, istest)
	@local_variables
	@create_mask
	@fill_mask
	@add_all_numbers_with_mask
	return answer
end

@create_mask+=
local mask = {}
for _, line in ipairs(lines) do
	local row = {}
	for i=1,#line do
		table.insert(row, false)
	end
	table.insert(mask, row)
end

@fill_mask+=
for i, line in ipairs(lines) do
	for j=1,cols do
		local sym = line:sub(j,j)
		if not tonumber(sym) and sym ~= "." then
			@fill_adjacent_mask
		end
	end
end

@local_variables+=
local rows = #lines
local cols = #lines[1]

@fill_adjacent_mask+=
for ii=-1,1 do
	for jj=-1,1 do
		if i+ii >= 1 and i+ii <= rows and j+jj >= 1 and j+jj <= cols then
			mask[i+ii][j+jj] = true
		end
	end
end


@add_all_numbers_with_mask+=
for i=1,rows do
	local line = lines[i]
	local off = 0
	while true do
		local c1,c2 = line:find("%d+")
		if c1 then
			@check_if_number_overlaps_mask
			@if_yes_add_number
		else
			break
		end
		line = line:sub(c2+1)
		off = off + c2
	end
end

@check_if_number_overlaps_mask+=
local overlaps = false
for j=c1,c2 do
	if mask[i][j+off] then
		overlaps = true
		break
	end
end

@local_variables+=
local answer = 0

@if_yes_add_number+=
if overlaps then
	answer = answer + tonumber(line:sub(c1,c2))
end

