##aoc
@variables+=
-- local test_input2 = [[
-- ]]

@variables+=
local answer_test2 = 400

@parts+=
@define_functions
function part2(lines, istest)
	local answer = 0
	@local_variables
	@split_patterns
	@foreach_pattern_find_reflection_with_smudge
	return answer
end

@foreach_pattern_find_reflection_with_smudge+=
for k, pattern in ipairs(patterns) do
	local ref = vim.deepcopy(pattern)
	local found = false
	local first_ref

	@find_vertical_reflection_line_initial
	@find_horizontal_reflection_line_initial

	assert(first_ref)

	local found = false
	for m=1,#ref do
		if found then
			break
		end
		for n=1,#ref[1] do 
			local pattern = vim.deepcopy(ref)


			@flip_at_location

			@find_vertical_reflection_line_with_smudge
			@find_horizontal_reflection_line_with_smudge
			if found then
				break
			end
		end
	end
	if not found then
		print(first_ref)
		assert(found)
	end
end

@flip_at_location+=
if pattern[m]:sub(n,n) == "#" then
	pattern[m] = pattern[m]:sub(1,n-1) .. "." .. pattern[m]:sub(n+1)
else
	pattern[m] = pattern[m]:sub(1,n-1) .. "#" .. pattern[m]:sub(n+1)
end

@find_vertical_reflection_line_initial+=
if not found then
	local vert_line
	@find_vertical_line

	if vert_line then
		first_ref = vert_line 
		found = true
	end
end

@find_horizontal_reflection_line_initial+=
if not found then
	local vert_line
	@transpose_pattern

	@find_vertical_line
	if vert_line then
		first_ref = 100*vert_line 
		found = true
	end
end

@find_vertical_reflection_line_with_smudge+=
if not found then
	local vert_line

	local old = -1
	if first_ref < 100 then
		old = first_ref
	end

	@find_vertical_line_no_duplicates
	if vert_line then
		answer = answer + vert_line
		found = true
	end
end

@find_horizontal_reflection_line_with_smudge+=
if not found then
	local vert_line
	@transpose_pattern

	local old = -1
	if first_ref >= 100 then
		old = first_ref / 100
	end

	@find_vertical_line_no_duplicates
	if vert_line then
		answer = answer + 100*vert_line 
		found = true
	end
end


@find_vertical_line_no_duplicates+=
for col=1,#pattern[1]-1 do
	local mirror = true
	for _, line in ipairs(pattern) do
		@check_if_line_is_at_line
	end
	if mirror and col ~= old then
		vert_line = col
		break
	end
end

