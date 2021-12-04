##day04
@day04.lua=
@variables
@read_input
@init_counters
@play_bingo
@show_result

@read_input+=
local f = io.open("input.txt")

@read_drawn_numbers
@read_boards

@read_drawn_numbers+=
local drawn = f:read()
drawn = vim.split(drawn, ",")
f:read()

@read_boards+=
local boards = {}
while true do
  local board = {}
  for i=1,5 do
    local line = f:read()
    if not line then
      break
    end
    local board_row = vim.split(line, " ")
    board_row = vim.tbl_filter(function(x) return x ~= "" end, board_row)
    table.insert(board, board_row)
  end

  if #board < 5 then
    break
  end

  table.insert(boards, board)
  f:read()
end

@play_bingo+=
for _, num in ipairs(drawn) do
  @cross_out_on_boards
  @check_win_boards
end

@cross_out_on_boards+=
for i=1,#boards do
  for j=1,5 do
    for k=1,5 do
      @cross_out_if_equal
    end
  end
end

@cross_out_if_equal+=
if boards[i][j][k] == num then
  boards[i][j][k] = ""
  col_count[i][j] = col_count[i][j] + 1
  row_count[i][k] = row_count[i][k] + 1
end

@variables+=
local col_count = {}
local row_count = {}

@init_counters+=
for i=1,#boards do
  col_count[i] = {0, 0, 0, 0, 0}
  row_count[i] = {0, 0, 0, 0, 0}
end

@check_win_boards+=
for i=1,#boards do
  for j=1,5 do
    if col_count[i][j] == 5 then
      @mark_board_as_win
      @check_if_last_to_win
      if last_win then
        @board_won
      end
    end
    if row_count[i][j] == 5 then
      @mark_board_as_win
      @check_if_last_to_win
      if last_win then
        @board_won
      end
    end
  end
  if won then
    break
  end
end

if won then
  break
end

@variables+=
local won = false
local win_num
local win_sum = 0

@board_won+=
won = true

win_num = num

@add_remaining_in_board

break

@add_remaining_in_board+=
for m=1,5 do
  for n=1,5 do
    if boards[i][m][n] ~= "" then
      @add_to_win_sum
    end
  end
end

@add_to_win_sum+=
win_sum = win_sum + tonumber(boards[i][m][n])

@show_result+=
if won then
  print("win_sum " .. win_sum)
  print("win_num " .. win_num)
  print("answer " .. win_num*win_sum)
else
  print("no winner :(")
end

@variables+=
local won_board = {}

@mark_board_as_win+=
won_board[i] = true

@check_if_last_to_win+=
local last_win = vim.tbl_count(won_board) == #boards
