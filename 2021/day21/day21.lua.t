##day21
@day21.lua=
@variables
@set_player_start_position
while true do
  @move_player
  @check_if_score_reached
  @switch_turn
  -- @show_state
end
@show_result

@set_player_start_position+=
local pos = {8, 2}
local turn = 1
local other = 2
local dice = 0
local rolled = 0

pos[1] = pos[1] - 1 
pos[2] = pos[2] - 1 

@move_player+=
local move = (dice+1) + (dice+2) + (dice+3)
rolled = rolled + 1
dice = (dice+3)%100
pos[turn] = (pos[turn]+move)%10

@variables+=
local scores = { 0, 0 }
local answer = 0

@check_if_score_reached+=
scores[turn] = scores[turn] + (pos[turn]+1)
if scores[turn] >= 1000 then
  answer = scores[other] * rolled * 3
  break
end

@show_result+=
print(string.format("answer: %d", answer))

@switch_turn+=
turn, other = other, turn

@show_state+=
print("pos " .. vim.inspect(pos))
print("scores " .. vim.inspect(scores))
