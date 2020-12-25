@*=
@functions
@read_input
--@read_test
--@solve_part_1
@solve_part_2
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

@solve_part_1+=
local cups = {}
@parse_cups

local cur = 1
for it=1,100 do
	local cv = cups[cur]
	@remove_three_cup_clockwise
	@select_destination_cup
	@place_three_cup_besides_destination_cup
	@select_new_current_cup
end

local c = tbl_find(cups, 1)
local res = ""
for i=1,#cups-1 do
	c = c + 1
	if c > #cups then c = 1 end
	res = res .. cups[c]
end

@parse_cups+=
local line = lines[1]
for i=1,string.len(lines[1]) do
	table.insert(cups, tonumber(string.sub(line, i, i)))
end

@remove_three_cup_clockwise+=
local n = cur+1
local removed = {}
local looped = false
for i=1,3 do
	if n > #cups then 
		n = 1 
	end
	table.insert(removed, 1, cups[n])
	table.remove(cups, n)
end

@functions+=
function tbl_find(t, x)
	for i,ti in ipairs(t) do
		if ti == x then return i end
	end
end
function tbl_max(t)
	local max = t[1]
	for _,ti in ipairs(t) do
		max = math.max(ti, max)
	end
	return max
end

@select_destination_cup+=
local v = cv-1
if v == 0 then
	v = 9
end

while vim.tbl_contains(removed, v) do
	v = v-1
	if v == 0 then
		v = 9
	end
end
local d = tbl_find(cups, v)

@place_three_cup_besides_destination_cup+=
for _, ri in ipairs(removed) do
	table.insert(cups, d+1, ri)
end

@select_new_current_cup+=
cur = tbl_find(cups, cv) + 1
if cur > #cups then cur = 1 end

@solve_part_2+=
local linked = {}
local cups = {}
@parse_cups
@build_linked_list

local cur = cups[1]
for it=1,10000000 do
	@put_pack_of_three_besides_dest
	@update_cur
end

@get_numbers_besides_one

@build_linked_list+=
for i=1,9 do
	local node = {}
	node.p = cups[tbl_find(cups, i)-1]
	if not node.p then node.p = 1000000 end

	node.n = cups[tbl_find(cups, i)+1]
	if not node.n then node.n = 10 end
	table.insert(linked, node)
end

table.insert(linked, {n = 11, p = cups[9]})

for i=11,999999 do
	table.insert(linked, {p = i-1, n = i+1})
end

table.insert(linked, {n = cups[1], p = 999999})

@put_pack_of_three_besides_dest+=
local n1 = linked[cur].n
local n2 = linked[n1].n
local n3 = linked[n2].n

local n4 = linked[n3].n

local d = cur-1
if d == 0 then d = 1000000 end

while d == n1 or d == n2 or d == n3 do
	d = d-1
	if d == 0 then d = 1000000 end
end

linked[cur].n = n4
linked[n4].p = cur


linked[n3].n = linked[d].n
linked[linked[d].n].p = n3

linked[d].n = n1
linked[n1].p = d


@update_cur+=
cur = linked[cur].n

@get_numbers_besides_one+=
local a = linked[1].n
local b = linked[a].n

print("a " .. a)
print("b " .. b)
print("mul " .. a*b)
