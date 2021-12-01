@*=
@requires
@declare_functions
@variables
@tokens
@expressions
@functions
@read_input
--@read_test
--@parse_input
--@process_input
--@display_result1
@parse_input2
@process_input2
@display_result2

@read_input+=
local lines = {}

for line in io.lines("input.txt") do
	table.insert(lines, line)
end

@read_test+=
local lines = {}

for line in io.lines("test.txt") do
	table.insert(lines, line)
end

@declare_functions+=
local eval, nextToken

@functions+=
function eval(rest, i)
	local res, op, token
	i = i or 1
	while i <= string.len(rest) do
		token, i = nextToken(rest, i)

		local val
		@if_open_paren_compute_value_first
		@if_number_convert_it

		@if_has_operation_do_it_or_just_save_in_res

		token, i = nextToken(rest, i)

		@if_close_paren_or_nil_return_value
		@if_operation_save_it
	end
	return res, i
end

function nextToken(rest, i)
	local c
	while true do
		c = string.sub(rest, i, i)
		if not c or c ~= " " then
			return c, i+1
		end
		i = i+1
	end
end

@if_open_paren_compute_value_first+=
if token == "(" then
	val, i = eval(rest, i)

@if_number_convert_it+=
else
	val = tonumber(token)
end

@if_has_operation_do_it_or_just_save_in_res+=
if op then
	if op == "+" then res = res + val
	elseif op == "*" then res = res * val end
else
	res = val
end

@if_close_paren_or_nil_return_value+=
if token == ")" then
	return res, i

@if_operation_save_it+=
else
	op = token
end

@parse_input+=
local sum = 0
for _,line in ipairs(lines) do
	sum = sum + eval(line)
end

@display_result1+=
print(sum)

@declare_functions+=
local parse_all

@functions+=
function parse_all(str)
	tokenize(str)
	@parse_tokens
	return exp
end

@declare_functions+=
local tokenize

@functions+=
function tokenize(str)
	@clear_tokens
	@tokenize_string
end

@clear_tokens+=
tokens = {}

@tokenize_string+=
local i = 1
while i <= string.len(str) do
	@get_character
	@skip_whitespace
	@tokenize_op
	@tokenize_par
	@tokenize_num
	@handle_error_tokenize
end

@get_character+=
local c = string.sub(str, i, i)

@skip_whitespace+=
if string.match(c, "%s") then
	i = i+1 

@tokens+=
-- closure-based object
local function AddToken() local self = { kind = "add" }
	@add_token_methods
return self end
local function MulToken() local self = { kind = "mul" }
	@mul_token_methods
return self end

@variables+=
tokens = {}

@tokenize_op+=
elseif c == "+" then table.insert(tokens, AddToken()) i = i+1
elseif c == "*" then table.insert(tokens, MulToken()) i = i+1


@tokens+=
local function RParToken() local self = { kind = "rpar" }
	@rpar_token_methods
return self end
local function LParToken() local self = { kind = "lpar" }
	@lpar_token_methods
return self end

@tokenize_par+=
elseif c == "(" then table.insert(tokens, LParToken()) i = i+1
elseif c == ")" then table.insert(tokens, RParToken()) i = i+1
	
@tokens+=
local function NumToken(num) local self = { kind = "num", num = num }
	@num_token_methods
return self end

@tokenize_num+=
elseif string.match(c, "%d") then 
	local parsed = string.match(string.sub(str, i), "%d+%.?%d*")
	i = i+string.len(parsed)
	table.insert(tokens, NumToken(tonumber(parsed))) 

@declare_functions+=
local nextToken

@variables+=
local token_index

@parse_tokens-=
token_index = 1

@functions+=
function nextToken()
	local token = tokens[token_index]
	token_index = token_index + 1
	return token
end

@declare_functions+=
local finish

@functions+=
function finish()
	return token_index > #tokens
end

@declare_functions+=
local getToken

@functions+=
function getToken()
	return tokens[token_index]
end

@parse_tokens+=
local exp = parse(0)

@declare_functions+=
local parse

@functions+=
function parse(p)
	local t = nextToken()
	if not t or not t.prefix then
		return nil
	end

	local exp = t.prefix()

	while exp and not finish() and p <= getToken().priority() do
		t = nextToken()
		exp = t.infix and t.infix(exp)
	end

	return exp
end

@add_token_methods+=
function self.prefix()
	return parse(self.priority())
end

@declare_functions+=
local AddExpression

@expressions+=
function AddExpression(left, right) 
	local self = { kind = "addexp", left = left, right = right }
	@add_exp_methods
return self end

@add_token_methods+=
function self.infix(left)
	local t = parse(self.priority())
	if not t then
		return nil
	end
	return AddExpression(left, t)
end
function self.priority() return priority_list["add"] end

@variables+=
local priority_list = {
	@priority_list
}

@priority_list+=
["add"] = 50,

@declare_functions+=
local MulExpression

@expressions+=
function MulExpression(left, right)
	local self = { kind = "mulexp", left = left, right = right }
	@mul_exp_methods
return self end

@mul_token_methods+=
function self.infix(left)
	local t = parse(self.priority())
	if not t then
		return nil
	end
	return MulExpression(left, t)
end
function self.priority() return priority_list["mul"] end

@priority_list+=
["mul"] = 30,

@lpar_token_methods+=
function self.prefix()
	local exp = parse(20)
	if not exp then
		return nil
	end
	@check_rpar
	return exp
end

@check_rpar+=
local rpar = nextToken()
if not rpar or rpar.kind ~= "rpar" then 
	errmsg = "Unmatched '('"
	return nil
end

@lpar_token_methods+=
function self.priority() return priority_list["lpar"] end

@priority_list+=
["lpar"] = 100,

@rpar_token_methods+=
function self.priority() return priority_list["rpar"] end

@priority_list+=
["rpar"] = 10,

@declare_functions+=
local NumExpression

@expressions+=
function NumExpression(num)
	local self = { kind = "numexp", num = BigNum.new(num) }
	@num_exp_methods
return self end

@num_token_methods+=
function self.prefix()
	return NumExpression(self.num)
end

@handle_error_tokenize+=
else
	error("Unexpected character insert " .. c)
	i = i+1
end

@add_exp_methods+=
function self.eval()
	local left = self.left.eval()
	local right = self.right.eval()
	return left + right
end

@mul_exp_methods+=
function self.eval()
	local left = self.left.eval()
	local right = self.right.eval()
	return left * right
end

@num_exp_methods+=
function self.eval()
	return self.num
end

@requires+=
require("BigNum")

@parse_input2+=
local sum = BigNum.new(0)
for _,line in ipairs(lines) do
	local exp = parse_all(line)
	sum = exp.eval() + sum
end

@display_result2+=
print(sum)
