@*=
@variables
@parts
@execute

@parts+=
function part1()
	@read_inputs_part1
	@show_answer
end

@read_inputs_part1+=
for line in io.lines("input.txt") do
	@parse_line
	@decide_if_one_range_fully_contain_other
	@if_so_add_count
end

@parse_line+=
local a1, a2, b1, b2 = line:match("(%d+)%-(%d+),(%d+)%-(%d+)")

a1 = tonumber(a1)
a2 = tonumber(a2)
b1 = tonumber(b1)
b2 = tonumber(b2)

@decide_if_one_range_fully_contain_other+=
local contain = 0
if a1 <= b1 and a2 >= b2 then
	contain = 1
elseif b1 <= a1 and b2 >= a2 then
	contain = 1
end

@variables+=
local total = 0

@if_so_add_count+=
total = total + contain

@show_answer+=
print(total)

@parts+=
function part2()
	@read_inputs_part2
	@show_answer
end

@read_inputs_part2+=
for line in io.lines("input.txt") do
	@parse_line
	@decide_if_one_range_fully_contain_other
	@decide_if_one_range_overlap_other
	@if_so_add_count
end

@decide_if_one_range_overlap_other+=
if a1 <= b1 and a2 >= b1 then
	contain = 1
elseif a1 <= b2 and a2 >= b2 then
	contain = 1
end

@execute+=
part2()
