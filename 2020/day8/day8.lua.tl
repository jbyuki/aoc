@*=
@requires
@variables
@functions
@read_input
-- @read_test
@parse_input
@process_input2
@process_input
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

@parse_input+=
local inss = {}
for _, line in ipairs(lines) do
	local ins, pm, num = string.match(line, "(%a+) ([+-])(%d+)")
	num = tonumber(num)
	if pm == "-" then
		num = num * (-1)
	end
	table.insert(inss, { ins, num })
end

@process_input+=
local ip = 1
local acc = 0
local visited = {}

while ip <= #inss do
	if visited[ip] then
		print("quit early")
		break
	end
	local ins, num = unpack(inss[ip])
	visited[ip] = true
	if ins == "acc" then
		acc = acc + num
		ip = ip+1
	elseif ins == "nop" then
		ip = ip+1
	elseif ins == "jmp" then
		ip = ip+num
	end
end

@process_input2+=
local ip = 1
local acc = 0
local visited = {}
local backtrack = {}
local changed = nil
local after_visited = {}
local limit = 100

while ip <= #inss do
	local ins, num = unpack(inss[ip])
	local pip = ip
	visited[ip] = true

	if changed then
		after_visited[ip] = true
	end

	if ins == "acc" then
		ip = ip+1
	elseif ins == "nop" then
		ip = ip+1
	elseif ins == "jmp" then
		ip = ip+num
	else
		error("unknown instruction")
	end

	if visited[ip] or (changed and after_visited[ip]) then
		@do_some_backtracking_work
	else
		backtrack[ip] = pip
	end
end

@do_some_backtracking_work+=
ip = pip
@backtrack_until_changed_instruction
@do_some_backtracking
limit = limit - 1
if limit == 0 then
	break
end

@backtrack_until_changed_instruction+=
if changed then
	while ip ~= changed do
		visited[ip] = nil
		ip = backtrack[ip]
		assert(ip, "error ip")
	end
	@change_back_instruction
	visited[ip] = nil
end

@change_back_instruction+=
local ins, num = unpack(inss[ip])
if ins == "jmp" then
	inss[ip] = { "nop", num }
elseif ins == "nop" then
	inss[ip] = { "jmp", num }
else
	error("changed acc instruction!")
end

@do_some_backtracking+=
ip = backtrack[ip]
while ip do
	local ins, num = unpack(inss[ip])
	visited[ip] = nil

	if ins == "jmp"  then
		inss[ip] = { "nop", num }
		changed = ip
		break
	elseif ins == "nop"  then
		inss[ip] = { "jmp", num }
		changed = ip
		break
	end
	ip = backtrack[ip]
end


@display_result+=
print(acc)
