##day10
@day10.lua=
@variables
for line in io.lines("input.txt") do
  @reset_stack
  for i=1,#line do
    local c = line:sub(i, i)
    @if_open_add_to_stack
    @if_close_pop_from_stack
  end
  @correct_incomplete_lines
end

@pick_median_score

@show_result
@show_result_2

@reset_stack+=
local stack = {}

@if_open_add_to_stack+=
if c == '(' or c == '[' or c == '<' or c == '{' then
  table.insert(stack, c)
end

@variables+=
local answer = 0

@if_close_pop_from_stack+=
if c == ')' then
  if #stack == 0 or stack[#stack] ~= '(' then
    answer = answer + 3
    stack = {}
    break
  end
  table.remove(stack)
end

@if_close_pop_from_stack+=
if c == ']' then
  if #stack == 0 or stack[#stack] ~= '[' then
    answer = answer + 57
    stack = {}
    break
  end
  table.remove(stack)
end

@if_close_pop_from_stack+=
if c == '}' then
  if #stack == 0 or stack[#stack] ~= '{' then
    answer = answer + 1197
    stack = {}
    break
  end
  table.remove(stack)
end

@if_close_pop_from_stack+=
if c == '>' then
  if #stack == 0 or stack[#stack] ~= '<' then
    answer = answer + 25137
    stack = {}
    break
  end
  table.remove(stack)
end

@show_result+=
print(answer)

@correct_incomplete_lines+=
if #stack > 0 then
  local score = 0
  for i=#stack,1,-1 do
    score = score * 5
    local c = stack[i]
    if c == "(" then score = score + 1
    elseif c == "[" then score = score + 2
    elseif c == "{" then score = score + 3
    elseif c == "<" then score = score + 4 end
  end
  table.insert(scores, score)
end

@variables+=
local scores = {}

@pick_median_score+=
table.sort(scores)

@show_result_2+=
print(scores[math.floor(#scores/2)+1])
