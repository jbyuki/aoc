@*=
@variables
@parts
@execute

@parts+=
function part1()
	@read_lines
	@read_and_find_start_of_marker
	@show_answer
end

@read_lines+=
local line = {}
for l in io.lines("input.txt") do
	line = l
	break
end

@read_and_find_start_of_marker+=
local sol
for i=1,#line-3 do
	@get_four_characters
	@check_if_all_are_different
end

@get_four_characters+=
local test = line:sub(i,i+3)

@check_if_all_are_different+=
local uniq = {}
for v in vim.gsplit(test, "") do
	uniq[v] = true
end

if vim.tbl_count(uniq) == #test then
	sol = i+(#test-1)
	break
end

@show_answer+=
print(sol)

@parts+=
function part2()
	@read_lines
	@read_and_find_start_of_message
	@show_answer
end

@read_and_find_start_of_message+=
local sol
for i=1,#line-13 do
	@get_14_characters
	@check_if_all_are_different
end

@get_14_characters+=
local test = line:sub(i,i+13)

@execute+=
part2()
