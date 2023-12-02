##aoc
@variables+=
local test_input = [[
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
]]

local answer_test1 = 8

@parts+=
function part1(lines, istest)
	@local_variables
	@parse_input
	return answer
end

@parse_input+=
local answer = 0
for _, line in ipairs(lines) do
	@get_game_id
	@split_by_set
	@check_if_sets_are_possible
	@if_possible_add_id
end

@get_game_id+=
local id = tonumber(line:match("^Game (%d+):"))

@split_by_set+=
local s, _ = line:find(":")
local rest = line:sub(s+1)
local sets = {}
for set in vim.gsplit(rest, ";") do
	table.insert(sets, set)
end

@check_if_sets_are_possible+=
local possible = true
for _, set in ipairs(sets) do
	@parse_set
	@check_maximum_for_each_color
end

@parse_set+=
local reds = set:match("(%d+) red")
local greens = set:match("(%d+) green")
local blues = set:match("(%d+) blue")

@check_maximum_for_each_color+=
if reds and tonumber(reds) > 12 then
	possible = false
end

if greens and tonumber(greens) > 13 then
	possible = false
end

if blues and tonumber(blues) > 14 then
	possible = false
end

@if_possible_add_id+=
if possible then
	answer = answer+ id
end

