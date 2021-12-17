##day17
@day17.lua=
@variables
@read_input
@parse_input
@compute_bounds
@try_all
@show_result

@read_input+=
local f = io.open("input.txt")
local line = f:read()
f:close()

@parse_input+=
local left, right, down, up = line:match("target area: x=(.+)%.%.(.+), y=(.+)%.%.(.+)")

left = tonumber(left)
right = tonumber(right)
down = tonumber(down)
up = tonumber(up)

@compute_bounds+=
local min_x = 0
local max_x = right

local min_y = down
local max_y = max_x


@try_all+=
local best
local count = 0

for vx=min_x,max_x do
  for vy=min_y,max_y do
    local cur_vx = vx
    local cur_vy = vy
    @check_if_reach_target
    if ok then
      count = count + 1
      @find_best_apex_height
    end
  end
end

@check_if_reach_target+=
local px = 0
local py = 0

local ok = false
local apex = 0

while true do
  if px > right or py < down then
    break
  end

  if px >= left and px <= right and py >= down and py <= up then
    ok = true
    break
  end

  px = px + cur_vx
  py = py + cur_vy

  cur_vy = cur_vy - 1
  if cur_vx < 0 then
    cur_vx = cur_vx + 1
  elseif cur_vx > 0 then
    cur_vx = cur_vx - 1
  end

  @is_apex
end

@is_apex+=
apex = math.max(apex, py)

@find_best_apex_height+=
if not best or best < apex then
  best = apex
end

@show_result+=
print(string.format("Best: %d", best))

@show_result+=
print(string.format("Count: %d", count))
