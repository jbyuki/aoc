@*=
@variables
@read_year_number
@ready_day_number
@create_pip
@save_into_file_callback
@create_pipes
@fetch_input_with_curl
@register_pipes
@wait_for_process_to_finish

@ready_day_number+=
local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
local nr = tonumber(cwd:match("day(%d+)"))

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

@read_year_number+=
local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":h:t")
local year = tonumber(cwd)

@fetch_input_with_curl+=
local handle, err = vim.loop.spawn("curl",
{
  stdio = {stdin, stdout, stderr},
  args = {"--cookie", ("session=%s"):format(vim.g.aoc_session), ("https://adventofcode.com/%d/day/%d/input"):format(year, nr)},
  cwd = ".",
}, vim.schedule_wrap(done))

assert(handle, err)

@variables+=
local finished = false

@save_into_file_callback+=
local function done(code, signal)
	@output_input_file
	finished = true
end

@wait_for_process_to_finish+=
vim.wait(10000, function() return finished end)

@output_input_file+=
input_file = io.open("input.txt", "w")
input_file:write(output)
input_file:close()
print(output)
