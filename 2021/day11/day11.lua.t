##day11
@day11=
@variables
for line in io.lines("input.txt") do
  @parse_line
end

for step=1,1000 do
  @reset_flashed
  @increase_all_energy_levels
  while #high_energy > 0 do
    @flash_current
  end
  @check_if_all_flashed
  @add_to_total_flashes
  -- if step == 1 then
    -- @show_terrain
  -- end
end
@show_result

@variables+=
local cave = {}

@parse_line+=
local row = {}
for i=1,#line do
  table.insert(row, tonumber(line:sub(i, i)))
end
table.insert(cave, row)

@increase_all_energy_levels+=
for i=1,#cave do
  for j=1,#(cave[i]) do
    cave[i][j] = cave[i][j] + 1
    if cave[i][j] > 9 then
      @collect_all_high_energies
      cave[i][j] = 0
      @increase_flashed
    end
  end
end

@reset_flashed+=
high_energy = {}

@collect_all_high_energies+=
table.insert(high_energy, {i, j})

@flash_current+=
local i, j = unpack(high_energy[#high_energy])
table.remove(high_energy)

for di=i-1,i+1 do
  for dj=j-1,j+1 do
    if di ~= 0 and dj ~= 0 and cave[di] and cave[di][dj] then
      if cave[di][dj] > 0 then
        cave[di][dj] = cave[di][dj] + 1
        @collect_all_high_energies_subsequent
      end
    end
  end
end

@variables+=
local total_flash = 0

@collect_all_high_energies_subsequent+=
if cave[di][dj] > 9 then
  table.insert(high_energy, {di, dj})
  cave[di][dj] = 0
  @increase_flashed
end

@show_terrain+=
for _, row in ipairs(cave) do 
  print(table.concat(row, ""))
end

@reset_flashed+=
local num_flashed = 0

@increase_flashed+=
num_flashed = num_flashed + 1

@add_to_total_flashes+=
total_flash = total_flash + num_flashed

@show_result+=
print(total_flash)

@check_if_all_flashed+=
if num_flashed == #cave * #(cave[1]) then
  print("All flashed at " .. step)
  break
end
