##day14
@day14=
@variables
@read_input
for i=1,40 do
  @init_next
  @apply_rules
  @cur_is_next
end
print(vim.inspect(seq_pairs))
@count_occurences
@substract_most_by_least
@show_result

@read_input+=
for line in io.lines("input.txt") do
  if line:match("^%u+ %-> %u+") then
    @read_rule
  elseif line:match("^%u+$") then
    @read_start_pattern
  end
end

@variables+=
local rules = {}

@read_rule+=
temp, sub = line:match("^(%u+) %-> (%u+)")
rules[temp] = sub

@variables+=
local seq

@read_start_pattern+=
seq = line:match("^(%u+)$")
@transform_initial_pair_list

@variables+=
local seq_pairs = {}

@transform_initial_pair_list+=
for i=1,#seq-1 do
  local pair = seq:sub(i,i+1)
  seq_pairs[pair] = seq_pairs[pair] or 0
  seq_pairs[pair] = seq_pairs[pair] + 1
end


@variables+=
local next_seq = {}

@init_next+=
next_seq = {}

@apply_rules+=
for pair, count in pairs(seq_pairs) do
  if rules[pair] then

    next_seq[pair:sub(1,1) .. rules[pair]] = next_seq[pair:sub(1,1) .. rules[pair]] or 0
    next_seq[pair:sub(1,1) .. rules[pair]] = next_seq[pair:sub(1,1) .. rules[pair]] + count

    next_seq[rules[pair] .. pair:sub(2,2)] = next_seq[rules[pair] .. pair:sub(2,2)] or 0
    next_seq[rules[pair] .. pair:sub(2,2)] = next_seq[rules[pair] .. pair:sub(2,2)] + count
  else
    next_seq[pair] = next_seq[pair] or 0
    next_seq[pair] = next_seq[pair] + count
  end
end

@cur_is_next+=
seq_pairs = next_seq

@variables+=
local occ = {}

@count_occurences+=
for pair, count in pairs(seq_pairs) do
  local c = pair:sub(1,1)
  occ[c] = occ[c] or 0
  occ[c] = occ[c] + count

  local c = pair:sub(2,2)
  occ[c] = occ[c] or 0
  occ[c] = occ[c] + count
end

for c,count in pairs(occ) do
  if c == seq:sub(1,1) then
    count = count + 1
  elseif c == seq:sub(#seq,#seq) then
    count = count + 1
  end
  occ[c] = count/2
end

@substract_most_by_least+=
local max_c, min_c
local max_o, min_o

for c,o in pairs(occ) do
  if not max_c or o > max_o then
    max_c = c
    max_o = o
  end

  if not min_c or o < min_o then
    min_c = c
    min_o = o
  end
end

local answer = max_o - min_o

@show_result+=
print(answer)
