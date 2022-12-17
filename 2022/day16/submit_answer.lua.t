##aoc
@*=
@variables
@functions
@parts
@read_test
@read_input
@read_status
@read_year_number
@ready_day_number

if status == "part1" then
	@execute_test_part1
elseif status == "part2" then
	@execute_test_part2
else
	print("Nothing to submit anymore :)")
end

@read_test+=
local test_lines = vim.split(test_input, "\n")
table.remove(test_lines)

@read_input+=
local input_lines = {}
for line in io.lines("input.txt") do
  table.insert(input_lines, line)
end

@execute_test_part1+=
local result_test = part1(test_lines, true)
if result_test == answer_test1 then
	print("Test Part 1 Passed!")
	@if_success_submit_part1
else
	print("Test Part 1 FAILED!")
	print(("Got \"%s\" but should be \"%s\""):format(result_test, answer_test1))
end

@execute_test_part2+=
local result_test = part2(test_lines, true)
if result_test == answer_test2 then
	print("Test Part 2 Passed!")
	@if_success_submit_part2
else
	print("Test Part 2 FAILED!")
	print(("Got \"%s\" but should be \"%s\""):format(result_test, answer_test2))
end

@if_success_submit_part1+=
local answer = part1(input_lines, false)
@convert_answer_and_print
@create_pipes
@done_callback
@submit_part1_answer_with_curl
@register_pipes
@wait_for_answer

@if_success_status_to_part2

@convert_answer_and_print+=
if type(answer) ~= "string" then
	answer = tostring(answer)
end
print(("Answer: %s"):format(answer))

@read_status+=
local f = io.open("status.txt")
local status
if not f then
	status = "part1"
else
	status = f:read()
	f:close()
end

@create_pipes+=
local stdin = vim.loop.new_pipe(false)
local stdout = vim.loop.new_pipe(false)
local stderr = vim.loop.new_pipe(false)

@register_pipes+=
stdout:read_start(function(err, data)
  vim.schedule(function()
    assert(not err, err)
    if data then
      @save_output
    end
  end)
end)

stderr:read_start(function(err, data)
  vim.schedule(function()
    assert(not err, err)
    if data then
    end
  end)
end)

@variables+=
local output = ""

@save_output+=
output = output .. data

@ready_day_number+=
local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
local nr = tonumber(cwd:match("day(%d+)"))

@read_year_number+=
local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":h:t")
local year = tonumber(cwd)

@submit_part1_answer_with_curl+=
local handle, err = vim.loop.spawn("curl",
{
  stdio = {stdin, stdout, stderr},
  args = {"-X POST", "--cookie", ("session=%s"):format(vim.g.aoc_session), ("https://adventofcode.com/%d/day/%d/answer"):format(year, nr), "-d", ("level=%d&answer=%s"):format(1, answer)},
	verbatim = true,
  cwd = ".",
}, vim.schedule_wrap(done))

assert(handle, err)

@variables+=
local submitted = false
local good_answer = false

@done_callback+=
local function done()
	@check_if_good_answer
	submitted = true
end

@wait_for_answer+=
vim.wait(10000, function() return submitted end)

@if_success_status_to_part2+=
if good_answer then
	local f = io.open("status.txt", "w")
	f:write("part2")
	f:close()
end

@check_if_good_answer+=
if output:match("That's not the right answer.") then
	print("Bad answer!")
	good_answer = false
elseif output:match("You gave an answer too recently") then
	local left_time = output:match("You have (.+) left")
	print(("Answered too recently. %s left"):format(left_time))
	good_answer = false
else
	print("Good answer!")
	good_answer = true
end

@if_success_submit_part2+=
local answer = part2(input_lines, false)
@convert_answer_and_print
@create_pipes
@done_callback
@submit_part2_answer_with_curl
@register_pipes
@wait_for_answer

@if_success_status_to_status_done

@submit_part2_answer_with_curl+=
local handle, err = vim.loop.spawn("curl",
{
  stdio = {stdin, stdout, stderr},
  args = {"-X POST", "--cookie", ("session=%s"):format(vim.g.aoc_session), ("https://adventofcode.com/%d/day/%d/answer"):format(year, nr), "-d", ("level=%d&answer=%s"):format(2, answer)},
	verbatim = true,
  cwd = ".",
}, vim.schedule_wrap(done))

assert(handle, err)

@if_success_status_to_status_done+=
if good_answer then
	local f = io.open("status.txt", "w")
	f:write("done!")
	f:close()
end
