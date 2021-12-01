@*=
@requires
@declare_functions
@variables
@tokens
@expressions
@functions
@read_input
--@read_test
@solve_part_1
@solve_part_2
@display_result

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

@solve_part_1+=
for _, line in ipairs(lines) do
	@parse_ingredients
	@parse_allergens
	@collect_allergens_candidates
end


for allergen, candidates_list in pairs(allergens or {}) do
	local inter = candidates_list[1]
	for _, candidates in ipairs(candidates_list) do
		@do_intersection_of_candidates_list
	end
	@collect_allergen_final_candidates
end

while vim.tbl_count(finals) > 0 do
	local changed = false
	for allergen,x in pairs(finals) do
		if #x == 1 then
			@remove_from_other_finals
			@remove_from_finals
			@choose_allergen_as_special_word
			changed = true
			break
		end
	end
	if not changed then
		print("Early quit!")
		break
	end
end

local count = 0
for _, ing in ipairs(ingredients) do
	for _, comp in ipairs(ing.list) do
		@check_if_comp_is_allergen
	end
end

@functions+=
function split_words(str, sep)
	local words = {}
	for word in vim.gsplit(str, sep or " ") do
		if string.len(vim.trim(word)) > 0 then
			table.insert(words, vim.trim(word))
		end
	end

	return words
end

@variables+=
local ingredients = {}

@parse_ingredients+=
local ing = {}
local op = string.find(line, "%(")
ing.list = split_words(string.sub(line, 1, op-1))

@parse_allergens+=
local cl = string.find(line, "%)")
local all_str  = string.sub(line, op + string.len("contains "), cl-1)
ing.all = split_words(string.sub(line, op + string.len("contains "), cl-1), ",")
table.insert(ingredients, ing)

@variables+=
local allergens = {}

@collect_allergens_candidates+=
for _, all in ipairs(ing.all) do
	allergens[all] = allergens[all] or {}
	table.insert(allergens[all], ing.list)
end

@functions+=
function intersection(a, b)
	local int = {}
	for _, x in ipairs(a) do
		if vim.tbl_contains(b, x) then
			table.insert(int, x)
		end
	end
	return int
end

@do_intersection_of_candidates_list+=
inter = intersection(inter, candidates)

@remove_from_other_finals+=
local word = x[1]
for _, l in pairs(finals) do
	@remove_word_from_l
end

@remove_word_from_l+=
for i,li in ipairs(l) do
	if li == word then
		table.remove(l, i)
		break
	end
end

@remove_from_finals+=
finals[allergen] = nil

@variables+=
local translation = {}

@choose_allergen_as_special_word+=
translation[word] = allergen

@variables+=
local finals = {}

@collect_allergen_final_candidates+=
finals[allergen] = inter

@check_if_comp_is_allergen+=
if not translation[comp] then 
	count = count + 1
end


@solve_part_2+=
local dangerous = vim.tbl_keys(translation)
table.sort(dangerous, function(a, b) return translation[a] < translation[b] end)
print(table.concat(dangerous, ","))
vim.api.nvim_buf_set_lines(0, -1, -1, true, { table.concat(dangerous, ",") })
