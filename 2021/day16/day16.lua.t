##day16
@day16.lua=
@requires
@variables
@functions
@read_input
@parse_hex
@parse_input
@show_result

@read_input+=
local f = io.open("input.txt","r")
local line = f:read()
f:close()

@variables+=
local output = {}

@parse_hex+=
for i=1,#line do
  local c = line:sub(i,i)
  if c == "0" then vim.list_extend(output, { 0, 0, 0, 0 })
  elseif c == "1" then vim.list_extend(output, { 0, 0, 0, 1 })
  elseif c == "2" then vim.list_extend(output, { 0, 0, 1, 0 })
  elseif c == "3" then vim.list_extend(output, { 0, 0, 1, 1 })
  elseif c == "4" then vim.list_extend(output, { 0, 1, 0, 0 })
  elseif c == "5" then vim.list_extend(output, { 0, 1, 0, 1 })
  elseif c == "6" then vim.list_extend(output, { 0, 1, 1, 0 })
  elseif c == "7" then vim.list_extend(output, { 0, 1, 1, 1 })
  elseif c == "8" then vim.list_extend(output, { 1, 0, 0, 0 })
  elseif c == "9" then vim.list_extend(output, { 1, 0, 0, 1 })
  elseif c == "A" then vim.list_extend(output, { 1, 0, 1, 0 })
  elseif c == "B" then vim.list_extend(output, { 1, 0, 1, 1 })
  elseif c == "C" then vim.list_extend(output, { 1, 1, 0, 0 })
  elseif c == "D" then vim.list_extend(output, { 1, 1, 0, 1 })
  elseif c == "E" then vim.list_extend(output, { 1, 1, 1, 0 })
  elseif c == "F" then vim.list_extend(output, { 1, 1, 1, 1 })
  end
end

@parse_input+=
local stack = {}
local ptr = 1

while true do
  @read_packet_version
  @read_packet_id
  @if_packet_is_literal
  @if_packet_is_operator
  @quit_if_stack_empty
end

@functions+=
function bin2dec(output)
  local res = 0
  for i=1,#output do
    res = res*2
    res = res + output[i]
  end
  return res
end

@read_packet_version+=
local version = bin2dec({ output[ptr], output[ptr+1], output[ptr+2] })
ptr = ptr + 3

@add_version_sum

@read_packet_id+=
local id = bin2dec({ output[ptr], output[ptr+1], output[ptr+2] })
ptr = ptr + 3

@if_packet_is_literal+=
if id == 4 then
  local cur_lit = {}
  while true do
    @check_if_first_bit_is_one
    @read_literal
    @quit_if_last_literal
  end
  @transform_lit_to_dec
  @check_if_stack_to_pop
end

@check_if_first_bit_is_one+=
local last_group = output[ptr]
ptr = ptr + 1

@quit_if_last_literal+=
if last_group == 0 then
  break
end

@if_packet_is_operator+=
if id ~= 4 then
  local op = {}
  @add_op_id
  @if_length_type_id_0
  @if_length_type_id_1
  @add_op_to_stack
end

@if_length_type_id_0+=
local length_type_id = output[ptr]
ptr = ptr + 1

if length_type_id == 0 then
  @read_op_total_length
end

@read_op_total_length+=
local total_len = bin2dec(vim.list_slice(output, ptr, ptr+14))
ptr = ptr + 15
op.total_len = ptr + total_len

@if_length_type_id_1+=
if length_type_id == 1 then
  @read_op_packet_count
end

@read_op_packet_count+=
local packet_count = bin2dec(vim.list_slice(output, ptr, ptr+10))
ptr = ptr + 11
op.packet_count = packet_count

@add_op_to_stack+=
table.insert(stack, op)

@check_if_stack_to_pop+=
while true do
  local last_op = stack[#stack]
  if not last_op then
    break
  end

  if last_op.total_len then
    if last_op.total_len == ptr then
      @apply_operation
      table.remove(stack)
    else
      break
    end
  elseif last_op.packet_count then
    last_op.packet_count = last_op.packet_count - 1
    if last_op.packet_count == 0 then
      @apply_operation
      table.remove(stack)
    else
      break
    end
  else
    break
  end
end

@variables+=
local version_sum = 0

@add_version_sum+=
version_sum = version_sum + version

@show_result+=
print(string.format("answer %d", version_sum))

@quit_if_stack_empty+=
if #stack == 0 then
  break
end

@parse_input-=
local cur_lits = {{}}

@read_literal+=
vim.list_extend(cur_lit, { output[ptr], output[ptr+1], output[ptr+2], output[ptr+3] })
ptr = ptr + 4

@transform_lit_to_dec+=
local num = bin2dec(cur_lit)
table.insert(cur_lits[#cur_lits], num)

@add_op_id+=
op.id = id

@apply_operation+=
if last_op.id == 0 then
  local sum = 0
  @do_sum_of_cur_lits
  table.remove(cur_lits)
  table.insert(cur_lits[#cur_lits], sum)
elseif last_op.id == 1 then
  local prod = 1
  @do_prod_of_cur_lits
  table.remove(cur_lits)
  table.insert(cur_lits[#cur_lits], prod)
elseif last_op.id == 2 then
  local cur_min = cur_lits[#cur_lits][1]
  @do_min_of_cur_lits
  table.remove(cur_lits)
  table.insert(cur_lits[#cur_lits], cur_min)
elseif last_op.id == 3 then
  local cur_max = cur_lits[#cur_lits][1]
  @do_max_of_cur_lits
  table.remove(cur_lits)
  table.insert(cur_lits[#cur_lits], cur_max)
elseif last_op.id == 5 then
  local left = cur_lits[#cur_lits][1]
  local right = cur_lits[#cur_lits][2]
  @do_greater_than
  table.remove(cur_lits)
  table.insert(cur_lits[#cur_lits], res)
elseif last_op.id == 6 then
  local left = cur_lits[#cur_lits][1]
  local right = cur_lits[#cur_lits][2]
  @do_less_than
  table.remove(cur_lits)
  table.insert(cur_lits[#cur_lits], res)
elseif last_op.id == 7 then
  local left = cur_lits[#cur_lits][1]
  local right = cur_lits[#cur_lits][2]
  @do_equal
  table.remove(cur_lits)
  table.insert(cur_lits[#cur_lits], res)
end

@do_sum_of_cur_lits+=
for _, num in ipairs(cur_lits[#cur_lits]) do
  sum = sum + num
end

@do_prod_of_cur_lits+=
for _, num in ipairs(cur_lits[#cur_lits]) do
  prod = prod * num
end

@do_min_of_cur_lits+=
for _, num in ipairs(cur_lits[#cur_lits]) do
  cur_min = math.min(cur_min, num)
end

@do_max_of_cur_lits+=
for _, num in ipairs(cur_lits[#cur_lits]) do
  cur_max = math.max(cur_max, num)
end

@do_greater_than+=
local res
if left > right then
  res = 1 
else
  res = 0 
end

@do_less_than+=
local res
if left < right then
  res = 1 
else
  res = 0 
end

@do_equal+=
local res
if left == right then
  res = 1 
else
  res = 0 
end

@add_op_to_stack+=
table.insert(cur_lits, {})

@show_result+=
print(string.format("op %d", vim.inspect(cur_lits[1][1])))
