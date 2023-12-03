##aoc
@variables+=
local answer_test2 = 467835

@parts+=
function part2(lines, istest)
	local answer
	@local_variables
	@create_mask
	@fill_mask_for_gear
	@fill_number_for_gears
	@only_add_exact_gears
	return answer
end

@fill_mask_for_gear+=
for i, line in ipairs(lines) do
	for j=1,cols do
		local sym = line:sub(j,j)
		if sym == "*" then
			@fill_adjacent_mask_with_index
		end
	end
end

@fill_adjacent_mask_with_index+=
for ii=-1,1 do
	for jj=-1,1 do
		if i+ii >= 1 and i+ii <= rows and j+jj >= 1 and j+jj <= cols then
			mask[i+ii][j+jj] = {i,j}
		end
	end
end

@fill_number_for_gears+=
for i=1,rows do
	local line = lines[i]
	local off = 0
	while true do
		local c1,c2 = line:find("%d+")
		if c1 then
			local index
			@check_if_number_overlaps_mask_and_save_index
			@if_yes_add_number_to_gear
		else
			break
		end
		line = line:sub(c2+1)
		off = off + c2
	end
end

@check_if_number_overlaps_mask_and_save_index+=
for j=c1,c2 do
	if mask[i][j+off] then
		index = mask[i][j+off]
		break
	end
end

@local_variables+=
local gears = {}

@if_yes_add_number_to_gear+=
if index then
	local num = tonumber(line:sub(c1,c2))
	local r = index[1]
	local c = index[2]
	if not gears[r] then
		gears[r] = {}
	end

	if not gears[r][c] then
		gears[r][c] = {}
	end
	table.insert(gears[r][c], num)
end

@only_add_exact_gears+=
for i, row in pairs(gears) do
	for j, tbl in pairs(row) do
		if #tbl == 2 then
			answer = answer + tbl[1] * tbl[2]
		end
	end
end

