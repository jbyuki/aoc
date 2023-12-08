##aoc
@variables+=
local answer_test2 = 6

@parts+=
@define_functions
function part2(lines, istest)
	@local_variables
	@read_instruction
	@read_lookup
	@get_start_nodes
	@find_loops_for_each_seed
	@find_first_hit_simultenous
	return answer
end


@get_start_nodes+=
local starts = {}
for node,_ in pairs(lookup) do
	if node:sub(3,3) == "A" then
		table.insert(starts, node)
	end
end

@step_all_paths+=
local next = {}
local inst = code:sub(ip, ip)

for _, node in ipairs(current) do
	local n = lookup[node][where[inst]]
	table.insert(next, n)
end

starts = next


@if_all_paths_end_with_z_stop+=
good = true
for _, n in ipairs(next) do
	if n:sub(3,3) ~= "Z" then
		good = false
		break
	end
end
if good then
	break
end


@find_loops_for_each_seed+=
for _, seed in ipairs(starts) do
	local paths = {}
	local current = seed
	local ip = 1
	paths[seed] = {}
	paths[seed][ip] = 0
	@step_path_until_looping
end

@local_variables+=
local where = {
	L = 1,
	R = 2,
}

@step_path_until_looping+=
local path_len = 1
while true do
	local inst = code:sub(ip,ip)
	current = lookup[current][where[inst]]
	if paths[current] and paths[current][ip] then
		@save_loop
		break
	end
	paths[current] = paths[current] or {}
	paths[current][ip] = path_len
	path_len = path_len + 1
	@advance_ip
end

@advance_ip+=
ip = ip + 1
if ip > #code then
	ip = 1
end

@local_variables+=
local loops = {}

@save_loop+=
local hitZ = 0
for elem,tbl in pairs(paths) do
	if elem:sub(3,3) == "Z" then
		for ip,step in pairs(tbl) do
			hitZ = math.max(hitZ, step) -- cheating
		end
	end
end

loops[seed] = {paths[current][ip], path_len - paths[current][ip], hitZ}

@define_functions+=
function decompose(N)
	local L = math.sqrt(N)
	local R = N
	local atoms = {}
	for C=2,L do
		if R == 1 then
			break
		end
		while R % C == 0 do
			R = R / C
			atoms[C] = atoms[C] or 0
			atoms[C] = atoms[C] + 1
		end
	end
	atoms[R] = atoms[R] or 0
	atoms[R] = atoms[R] + 1
	return atoms
end

@find_first_hit_simultenous+=
local LCM = {}
local min_atoms = {}

for _, info in pairs(loops) do
	local atoms = decompose(info[2])
	@add_atoms
end

@multiply_atoms

@add_atoms+=
for atom, c in pairs(atoms) do
	if not min_atoms[atom] or min_atoms[atom] < c then
		min_atoms[atom] = c
	end
end

@multiply_atoms+=
answer = 1
for num, pow in pairs(min_atoms) do
	answer = answer * (num ^ pow)
end
-- this problem could be potentially a lot harder but the input is made easy so not too worry

