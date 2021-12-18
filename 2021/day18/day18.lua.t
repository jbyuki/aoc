##day18
@day18.lua=
@variables
@functions
@read_input
-- @parse_lines
-- @compute_magnitude
@parse_each_line
@compute_max_mag_any_two
@show_result

@variables+=
local lines = {}

@read_input+=
for line in io.lines("input.txt") do
  table.insert(lines, line)
end

@functions+=
function parse_pair(line, ptr)
  assert(line:sub(ptr, ptr) == "[", "no opening bracket")
  ptr = ptr + 1

  local elem = {}

  local child
  @if_number_parse_atom
  @if_opening_bracket_parse_pair
  elem.left = child
  child.parent = elem

  @parse_comma

  @if_number_parse_atom
  @if_opening_bracket_parse_pair
  elem.right = child
  child.parent = elem

  assert(line:sub(ptr, ptr) == "]", "no closing bracket")
  ptr = ptr + 1
  return elem, ptr
end

@if_number_parse_atom+=
local rest = line:sub(ptr)
if rest:match("^%d") then
  child, ptr = parse_atom(line, ptr)

@if_opening_bracket_parse_pair+=
else
  child, ptr = parse_pair(line, ptr)
end

@functions+=
function parse_atom(line, ptr)
  local elem = {}
  @parse_number
  return elem, ptr
end

@parse_number+=
local rest = line:sub(ptr)
local num = rest:match("^(%d+)")
ptr = ptr + #num 

elem.num = tonumber(num)

@parse_comma+=
assert(line:sub(ptr,ptr) == ",", "comma mismatch!")
ptr = ptr + 1

@parse_lines+=
local root
for _, line in ipairs(lines) do
  if root then
    local new_root = {}
    new_root.left = root
    new_root.right = parse_pair(line, 1)
    @link_parent_to_new_root
    root = new_root
  else
    root = parse_pair(line, 1)
  end

  @reduce_sum
end

@link_parent_to_new_root+=
new_root.left.parent = new_root
new_root.right.parent = new_root

@functions+=
function show_pair(ast) 
  local result = ""
  @if_pair_recurse
  @if_number_show
  return result
end

@if_pair_recurse+=
if ast.left and ast.left then
  result = string.format("[%s,%s]",
    show_pair(ast.left),
    show_pair(ast.right))

@if_number_show+=
else
  result = string.format("%d",ast.num)
end

@reduce_sum+=
while true do
  local did_something = false
  @search_for_leftmost_nested_pair_and_explode
  @search_for_leftmost_number_greater_than_10
  @if_none_break
end

@functions+=
function search_nested(node, level)
  if node.left and node.right and node.left.num and node.right.num and level >= 4 then
    return node
  end

  if node.left and node.right then
    local found = search_nested(node.left, level+1)
    if found then return found end

    local found = search_nested(node.right, level+1)
    if found then return found end
  end
end

@search_for_leftmost_nested_pair_and_explode+=
local node = search_nested(root, 0)
if node then
  @search_for_number_just_right
  @search_for_number_just_left
  @do_explode
  did_something = true

@if_none_break+=
if not did_something then
  break
end

@functions+=
function search_just_left(node)
  if not node.parent then
    return nil
  end

  if node.parent.right == node then
    return rightmost_number(node.parent.left)
  end

  return search_just_left(node.parent)
end

function rightmost_number(node)
  if node.num then
    return node
  end
  return rightmost_number(node.right)
end

function search_just_right(node)
  if not node.parent then
    return nil
  end

  if node.parent.left == node then
    return leftmost_number(node.parent.right)
  end

  return search_just_right(node.parent)
end

function leftmost_number(node)
  if node.num then
    return node
  end
  return leftmost_number(node.left)
end

@search_for_number_just_right+=
local just_right_node = search_just_right(node)

@search_for_number_just_left+=
local just_left_node = search_just_left(node)

@do_explode+=
if just_left_node then
  just_left_node.num = just_left_node.num + node.left.num
end

if just_right_node then
  just_right_node.num = just_right_node.num + node.right.num
end

if node.parent.right == node then
  node.parent.right = { num = 0, parent = node.parent }
else
  node.parent.left = { num = 0, parent = node.parent }
end

@show_result+=
-- print(show_pair(root))

@functions+=
function search_10_greater(node)
  if node.num and node.num >= 10 then
    return node
  end

  if node.left and node.right then
    local found = search_10_greater(node.left)
    if found then
      return found
    end
    local found = search_10_greater(node.right)
    if found then
      return found
    end
  end
end

@search_for_leftmost_number_greater_than_10+=
else 
  local node = search_10_greater(root)
  if node then
    @do_split
    did_something = true
  end
end

@do_split+=
node.left = { num = math.floor(node.num/2), parent = node }
node.right = { num = math.ceil(node.num/2), parent = node }
node.num = nil

@functions+=
function compute_magnitude(node)
  local sum = 0
  if node.num then
    if node.parent.left == node then
      sum = sum + node.num
    else
      sum = sum + node.num
    end
  else
    sum = sum + 3 * compute_magnitude(node.left)
    sum = sum + 2 * compute_magnitude(node.right)
  end
  return sum
end

@compute_magnitude+=
local mag = compute_magnitude(root)

@show_result+=
-- print(string.format("Magnitude: %d", mag))

@parse_each_line+=
local parsed = {}
for _, line in ipairs(lines) do
  local node = parse_pair(line, 1)
  table.insert(parsed, node)
end

@compute_max_mag_any_two+=
for i=1,#parsed do
  for j=1,#parsed do
    if i ~= j then
      @do_deepcopy_with_parent_update
      @reduce_sum
      @compute_mag_and_pick_best
    end
  end
end

@functions+=
function copy_node(node)
  local new_node = {}
  if node.num then
    new_node.num = node.num
  else
    new_node.left = copy_node(node.left)
    new_node.right = copy_node(node.right)
    new_node.left.parent = new_node
    new_node.right.parent = new_node
  end
  return new_node
end

@do_deepcopy_with_parent_update+=
local root = {}
root.left = copy_node(parsed[i])
root.right = copy_node(parsed[j])
root.left.parent = root
root.right.parent = root

@variables+=
local best_mag

@compute_mag_and_pick_best+=
local mag = compute_magnitude(root)
if not best_mag or best_mag < mag then
  best_mag = mag
end

@show_result+=
print(string.format("best mag %d", best_mag))
