##day24
@day24.lua=
@variables
@parse_input
@set_input_number
@init_registers
@run_program
@print_reg_content

@variables+=
local program = {}

@parse_input+=
for line in io.lines("input.txt") do
  local inst = {}
  @parse_instruction
  table.insert(program, inst)
end

@parse_instruction+=
inst = vim.split(line, " ")

@init_registers+=
local regs = { }
regs["x"] = 0
regs["y"] = 0
regs["z"] = 0
regs["w"] = 0

@run_program+=
for _, inst in ipairs(program) do
  local op = inst[1]
  if op == "inp" then
    @read_from_input
  else
    local is_num = string.match(inst[3], "%d")
    if op == "add" then
      @do_add
    elseif op == "mul" then
      @do_mul
    elseif op == "eql" then
      @do_eql
    elseif op == "div" then
      @do_div
    elseif op == "mod" then
      @do_mod
    end
  end
end

@set_input_number+=
-- local input = {
  -- 1, 1, 1, 1, 1, 
  -- 1, 1, 1, 1, 1,
  -- 1, 1, 9, 9,
-- }

-- 15
-- ,-5
-- ,-6
-- ,-7
-- ,-9
-- ,-6
-- ,-14
-- ,-3
-- ,-1
-- ,-3
-- ,-4
-- ,-6
-- ,-7
-- ,-1

local input = {
  1 ,1 ,9 ,1 ,1 ,3 ,1 ,6 ,7 ,1 ,1 ,8 ,1 ,6
}

@read_from_input+=
regs[inst[2]] = input[1]
table.remove(input, 1)

@do_add+=
if is_num then
  regs[inst[2]] = regs[inst[2]] + tonumber(inst[3])
else
  regs[inst[2]] = regs[inst[2]] + regs[inst[3]]
end

@do_mul+=
if is_num then
  regs[inst[2]] = regs[inst[2]] * tonumber(inst[3])
else
  regs[inst[2]] = regs[inst[2]] * regs[inst[3]]
end

@do_eql+=
if is_num then
  if regs[inst[2]] == tonumber(inst[3]) then
    regs[inst[2]] = 1
  else
    regs[inst[2]] = 0
  end
else
  if regs[inst[2]] == regs[inst[3]] then
    regs[inst[2]] = 1
  else
    regs[inst[2]] = 0
  end
end

@do_mod+=
if is_num then
  regs[inst[2]] = math.fmod(regs[inst[2]], tonumber(inst[3]))
else
  regs[inst[2]] = math.fmod(regs[inst[2]], regs[inst[3]])
end

@do_div+=
if is_num then
  regs[inst[2]] = math.floor(regs[inst[2]] / tonumber(inst[3]))
else
  regs[inst[2]] = math.floor(regs[inst[2]] / regs[inst[3]])
end

@print_reg_content+=
print(("[w] = %d"):format(regs["w"]))
print(("[x] = %d"):format(regs["x"]))
print(("[y] = %d"):format(regs["y"]))
print(("[z] = %d"):format(regs["z"]))
