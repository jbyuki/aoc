@*=
@requires
@variables
@functions
@read_input
@process_input
@display_result

@read_input+=
passport = {}
cur_passport = ""

for line in io.lines("input.txt") do
	if line == "" then
		table.insert(passport, cur_passport)
		cur_passport = ""
	else
		cur_passport = cur_passport .. " " .. line
	end
end

if cur_passport ~= "" then
	table.insert(passport, cur_passport)
end

@process_input+=
required_fields = { "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid" }
valid = 0

for _, p in ipairs(passport) do
	local fields = {}
	for capture, value in string.gmatch(p, "(%a+):(%S+)") do
		fields[capture] = value
	end

	local is_valid = true
	for _, r in ipairs(required_fields) do
		if not fields[r] then
			is_valid = false
			break
		end
	end

	if is_valid then
		local not_valid = false
		@check_fields_validity
		if is_valid then
			valid = valid + 1
		end
	end
end

@display_result+=
print("valid : " .. valid)

@functions+=
function in_range(x, a, b)
	return x and x >= a and x <= b
end

@check_fields_validity+=
local year = tonumber(fields["byr"])
is_valid = is_valid and in_range(year, 1920, 2002)

local year = tonumber(fields["iyr"])
is_valid = is_valid and in_range(year, 2010, 2020)

local year = tonumber(fields["eyr"])
is_valid = is_valid and in_range(year, 2020, 2030)

local height = fields["hgt"]

local cm = tonumber(string.match(height, "^(%d+)cm$"))
local inch = tonumber(string.match(height, "^(%d+)in$"))
is_valid = is_valid and (in_range(cm, 150, 193) or (in_range(inch, 59, 76)))

local hair = fields["hcl"]

is_valid = is_valid and (string.match(hair, "^#[0-9a-f]+$") and string.len(hair) == 7)

local color = { amb = true, blu = true, brn = true, gry = true, grn = true, hzl = true, oth = true }
local eye = fields["ecl"]

is_valid = is_valid and color[eye]

local pid = fields["pid"]

is_valid = is_valid and (string.match(pid, "^%d+$") and string.len(pid) == 9)
