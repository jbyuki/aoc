##day12
@day12.lua=
@variables
@functions
@read_input
@count_small_caves
@add_initial_path_in_open
while #open > 0 do
  @get_current_path
  @extend_paths
end
@show_result

@variables+=
local paths = {}

@read_input+=
for line in io.lines("input.txt") do
  local parsed = vim.split(line, "-")
  local node_a = parsed[1]
  local node_b = parsed[2]

  if node_b ~= "start" then
    paths[node_a] = paths[node_a] or {}
    table.insert(paths[node_a], node_b)
  end

  if node_a ~= "start" then
    paths[node_b] = paths[node_b] or {}
    table.insert(paths[node_b], node_a)
  end
end

@variables+=
local small_caves_count = 0
local small_caves = {}

@count_small_caves+=
for name, _ in pairs(paths) do
  if name:match("^%l") and name ~= "start" and name ~= "end" then
    small_caves[name] = true
    small_caves_count = small_caves_count + 1
  end
end

@add_initial_path_in_open+=
local open = {}
table.insert(open, { 
  pos = "start", 
  visited = {},
  twice = false,
})

@get_current_path+=
local path = open[#open]
table.remove(open)

@extend_paths+=
for _, next in ipairs(paths[path.pos]) do
  if next == "end" then 
    @add_to_final_paths
  elseif small_caves[next] then
    @check_that_small_cave_not_visited
  else
    @add_to_next_anyway
  end
end

@variables+=
local possible_paths = 0

@add_to_final_paths+=
possible_paths = possible_paths + 1

@show_result+=
print(possible_paths)

@check_that_small_cave_not_visited+=
if not path.visited[next] or not path.twice then
  local next_path = vim.deepcopy(path)
  if path.visited[next] then
    next_path.twice = true
  end
  next_path.pos = next
  next_path.visited[next] = true
  table.insert(open, next_path)
end

@add_to_next_anyway+=
local next_path = vim.deepcopy(path)
next_path.pos = next
table.insert(open, next_path)

