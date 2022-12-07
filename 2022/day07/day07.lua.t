@*=
@variables
@functions
@parts
@execute

@parts+=
function part1()
	@read_lines
	@parse_lines_and_populate_directories
	@compute_directory_size_recursive
	@search_for_all_directories_which_satisfy_condition
	@sum_all_directories_candidates
	@show_answer
end

@read_lines+=
local lines = {}
for line in io.lines("input.txt") do
	table.insert(lines, line)
end


@parse_lines_and_populate_directories+=
local idx = 2
while idx <= #lines do
	@parse_command
	@read_command_output_and_take_action
end

@parse_command+=
local cmd = lines[idx]:match("%$ (%l+)")

@variables+=
local root = { name = "/", type = "dir", entries = {}}
local curdir = root

@read_command_output_and_take_action+=
if cmd == "cd" then
	local nextdir = lines[idx]:match("%$ cd (.+)")
	if not curdir.entries[nextdir] then
		@create_directory
	end
	curdir = curdir.entries[nextdir]
	idx = idx + 1
end

@create_directory+=
curdir.entries[nextdir] = { name = nextdir, type = "dir", entries = { [".."] = curdir }}

@read_command_output_and_take_action+=
if cmd == "ls" then
	idx = idx + 1
	while idx <= #lines and lines[idx]:sub(1,1) ~= "$" do
		@create_file_in_directory
		idx = idx + 1
	end
end

@create_file_in_directory+=
local filesize, filename = lines[idx]:match("(%S+) (%S+)")
if filesize == "dir" then
	curdir.entries[filename] = { name = filename, type = "dir", entries = { [".."] = curdir }}
else
	curdir.entries[filename] = { name = filename, type = "file", size = tonumber(filesize) }
end

@functions+=
function update_size(dir)
	local total = 0
	for name, entry in pairs(dir.entries) do
		if name ~= ".." then
			if entry.type == "dir" then
				total = total + update_size(entry)
			else
				total = total + entry.size
			end
		end
	end
	dir.size = total
	return total
end

@compute_directory_size_recursive+=
update_size(root)

@functions+=
function search_dir(dir, limit, candidates) 
	if dir.size  <= limit then
		table.insert(candidates, dir)
	end

	for name, entry in pairs(dir.entries) do
		if name ~= ".." then
			if entry.type == "dir" then
				search_dir(entry, limit, candidates)
			end
		end
	end
end

@search_for_all_directories_which_satisfy_condition+=
local candidates = {}
search_dir(root, 100000, candidates)

@sum_all_directories_candidates+=
local total = 0
for _, dir in ipairs(candidates) do
	total = total + dir.size
end

@show_answer+=
print(total)

@parts+=
function part2()
	@read_lines
	@parse_lines_and_populate_directories
	@compute_directory_size_recursive
	@search_for_all_directories_which_satisfy_condition
	@compute_space_to_release
	@find_directory_to_delete
	@show_answer
end

@compute_space_to_release+=
local free = (70000000 - root.size)
local release = 30000000 - free

@functions+=
function get_dir_sizes(dir, sizes)
	table.insert(sizes, dir.size)

	for name, entry in pairs(dir.entries) do
		if name ~= ".." then
			if entry.type == "dir" then
				get_dir_sizes(entry, sizes)
			end
		end
	end
end

@find_directory_to_delete+=
local sizes = {}
get_dir_sizes(root, sizes)

sizes = vim.tbl_filter(function(size) return size >= release end, sizes)
table.sort(sizes)
local total = sizes[1]

@execute+=
part2()
