@*=
@variables
@functions
@parts
@execute

@parts+=
function part1()
	@part1_variables
	@read_lines
	@execute_instructions
	@add_signal_strenghts
	@show_answer
end

@read_lines+=
local lines = {}
for line in io.lines("input.txt") do
  table.insert(lines, line)
end

@execute_instructions+=
for _, line in ipairs(lines) do
	@parse_command
	@execute_instruction_and_save_strenghts
end

@parse_command+=
local tok = vim.split(line, " ")

@part1_variables+=
local strenghs = {}
local cycles = 0
local X = 1

@execute_instruction_and_save_strenghts+=
if tok[1] == "noop" then
	cycles = cycles + 1
	strenghs[cycles] = cycles * X

@execute_instruction_and_save_strenghts+=
elseif tok[1] == "addx" then
	local opnd = tonumber(tok[2])
	cycles = cycles + 1

	strenghs[cycles] = cycles * X
	cycles = cycles + 1
	strenghs[cycles] = cycles * X
	X = X + opnd
end

@add_signal_strenghts+=
local total = 0
for i=20,221,40 do
	total = total + strenghs[i]
end

@show_answer+=
print(total)

@parts+=
function part2()
	@part2_variables
	@read_lines
	@execute_instructions_drawing
	@show_answer_drawing
end


@execute_instructions_drawing+=
for _, line in ipairs(lines) do
	@parse_command
	@execute_instruction_and_do_drawing
end

@part2_variables+=
local X = 1
local cycles = 0
local drawing = {}

@execute_instruction_and_do_drawing+=
if tok[1] == "noop" then
	cycles = cycles + 1

	@determine_if_pixel_is_lit
	@put_pixel_in_drawing

@determine_if_pixel_is_lit+=
local lit = math.abs(((cycles-1) % 40) - X) <= 1

@put_pixel_in_drawing+=
local row = math.floor((cycles-1)/40)+1
local col = ((cycles-1)%40)+1

drawing[row] = drawing[row] or {}
drawing[row][col] = lit and "#" or "."

@execute_instruction_and_do_drawing+=
elseif tok[1] == "addx" then
	local opnd = tonumber(tok[2])
	cycles = cycles + 1

	@determine_if_pixel_is_lit
	@put_pixel_in_drawing

	cycles = cycles + 1


	@determine_if_pixel_is_lit
	@put_pixel_in_drawing
	X = X + opnd
end

@show_answer_drawing+=
out = io.open("out.txt", "w")
for _, row in ipairs(drawing) do
	-- print(table.concat(row))
	out:write(table.concat(row) .. "\n")
end

@execute+=
part2()
