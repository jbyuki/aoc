##day03
@day03.lua=
@functions
@read_input
@compute_gamma_epsilon
@compute_o2_generator
@compute_o2_scrubber
@convert_binary_to_decimal
@show_result

@read_input+=
local lines = {}
for line in io.lines("input.txt") do
  table.insert(lines, line)
end

@compute_gamma_epsilon+=
local count_zero = {}
for i=1,#lines do
  for j=1,#(lines[1]) do
    if lines[i]:sub(j,j) == "0" then
      count_zero[j] = count_zero[j] or 0
      count_zero[j] = count_zero[j] + 1
    end
  end
end

local gamma = {}
local epsilon = {}
for j=1,#(lines[1]) do
  if count_zero[j] > #lines - count_zero[j] then
    table.insert(gamma, "0")
    table.insert(epsilon, "1")
  else
    table.insert(gamma, "1")
    table.insert(epsilon, "0")
  end
end

@show_result+=
print("gamma " .. table.concat(gamma))
print("epsilon " .. table.concat(epsilon))

@functions+=
function bin2dec(barr)
  local res = 0
  for i=1,#barr do
    res = res * 2
    if barr[i] == "1" then
      res = res + 1
    end
  end
  return res
end

@convert_binary_to_decimal+=
local gamma_dec = bin2dec(gamma)
local epsilon_dec = bin2dec(epsilon)

@show_result+=
print("gamma_dec " .. gamma_dec)
print("epsilon_dec " .. epsilon_dec)

print("answer " .. gamma_dec * epsilon_dec)

@functions+=
function count_zero_at(tab, j)
  local count_zero = 0
  for i=1,#tab do
    if tab[i]:sub(j,j) == "0" then
      count_zero = count_zero + 1
    end
  end
  return count_zero
end

function select_only(tab, j, which)
  local selected = {}
  for i=1,#tab do
    if tab[i]:sub(j,j) == which then
      table.insert(selected, tab[i])
    end
  end
  return selected
end

@compute_o2_generator+=
local o2_gen_cand = lines
for j=1,#(lines[1]) do
  local count_zero = count_zero_at(o2_gen_cand, j)
  if count_zero > #o2_gen_cand - count_zero then
    o2_gen_cand = select_only(o2_gen_cand, j, "0")
  elseif count_zero < #o2_gen_cand - count_zero then
    o2_gen_cand = select_only(o2_gen_cand, j, "1")
  else
    o2_gen_cand = select_only(o2_gen_cand, j, "1")
  end

  if #o2_gen_cand == 1 then
    break
  end
end

local o2_generator = o2_gen_cand[1]

@compute_o2_scrubber+=
local o2_scrub_cand = lines
for j=1,#(lines[1]) do
  local count_zero = count_zero_at(o2_scrub_cand, j)
  if count_zero > #o2_scrub_cand - count_zero then
    o2_scrub_cand = select_only(o2_scrub_cand, j, "1")
  elseif count_zero < #o2_scrub_cand - count_zero then
    o2_scrub_cand = select_only(o2_scrub_cand, j, "0")
  else
    o2_scrub_cand = select_only(o2_scrub_cand, j, "0")
  end

  if #o2_scrub_cand == 1 then
    break
  end
end

local o2_scrubber = o2_scrub_cand[1]

@show_result+=
print("o2_generator " .. o2_generator)
print("o2_scrubber " .. o2_scrubber)

@convert_binary_to_decimal+=
local o2_generator_dec = bin2dec(vim.split(o2_generator, ""))
local o2_scrubber_dec = bin2dec(vim.split(o2_scrubber, ""))

@show_result+=
print("o2_generator_dec " .. o2_generator_dec)
print("o2_scrubber_dec " .. o2_scrubber_dec)

print("answer part 2 " .. o2_generator_dec * o2_scrubber_dec)
