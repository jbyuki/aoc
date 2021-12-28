##day21_part2
@day21_part2.lua=
@requires
@variables
@create_state_grid
@set_player_initial_pos
while true do
  @break_if_no_more_player_in_one_state_grid
  @create_empty_state_next
  @play_quantum

  -- @show_non_zero_states
end

@show_result

@variables+=
local turn = 1
local other = 2

@create_state_grid+=
local states = {}

for player=1,2 do
  states[player] = {}
  for pos=0,9 do
    states[player][pos] = {}
    for score=0,20 do
      states[player][pos][score] = zero
    end
  end
end

@set_player_initial_pos+=
states[1][8-1][0] = BigNum.new(1)
states[2][2-1][0] = BigNum.new(1)

local total_count = {
  BigNum.new(1),
  BigNum.new(1),
}

@play_quantum+=
for pos=0,9 do
  for score=0,20 do
    if states[turn][pos][score] > zero then
      for die1=1,3 do
        for die2=1,3 do
          for die3=1,3 do
            @move_player_accordingly
          end
        end
      end
    end
  end
end
@switch_turn

@create_empty_state_next+=
local total_next = zero

@move_player_accordingly+=
local move = die1+die2+die3
new_pos = (pos + move) % 10
new_score = score + (new_pos+1)

@check_if_win_add_winning

if not win then
  next_state[new_pos][new_score] = next_state[new_pos][new_score] + states[turn][pos][score]
  total_next = total_next + states[turn][pos][score]
end

@create_empty_state_next+=
local next_state = {}
for pos=0,9 do
  next_state[pos] = {}
  for score=0,20 do
    next_state[pos][score] = zero
  end
end

@switch_turn+=
states[turn] = next_state
total_count[turn] = total_next
turn, other = other, turn

@variables+=
local won = { 0, 0 }

@check_if_win_add_winning+=
local win = new_score >= 21
if win then
  won[turn] = won[turn] + states[turn][pos][score] * total_count[other]
end

@variables+=
local zero = BigNum.new(0)

@break_if_no_more_player_in_one_state_grid+=
local has_player = false
for pos=0,9 do
  for score=0,20 do
    if states[turn][pos][score] > zero then
      has_player = true
      break
    end
  end

  if has_player then
    break
  end
end

if not has_player then
  break
end

@show_result+=
print(won[1])
print(won[2])
print("Done!")

local a = BigNum.new(444356092776315)
print(a)

@requires+=
require"BigNum"

@show_non_zero_states+=
local sum = zero
for pos=0,9 do
  for score=0,20 do
    if states[other][pos][score] ~= zero then
      sum = sum + states[other][pos][score]
      print(string.format("[%s][%s] = %s", pos, score, states[other][pos][score]))
    end
  end
end
print(sum)
print(total_count[other])

@show_result+=
local a = BigNum.new(2)
local b = BigNum.new(2)
