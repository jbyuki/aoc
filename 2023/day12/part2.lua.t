##aoc
@variables+=
-- local test_input2 = [[
-- ????.????. 1,1
-- ]]

@variables+=
local answer_test2 = 525152

@parts+=
@define_functions
function part2(lines, istest)
	@local_variables
	@foreach_line_find_arrangements_with_dp
	return answer
end

@foreach_line_find_arrangements_with_dp+=
local answer = 0
for l, line in ipairs(lines) do
	@parse_line
	print(line)
	local num_unfolds = 5
	@unfold
	@compute_accumulated_min_length
	@compute_poss_with_dp
	@add_posibility
	print(valid)
end

@unfold+=
local concat_line = {}
local tbl_seq = {}
for _=1,num_unfolds do
	table.insert(concat_line, line)
	table.insert(tbl_seq, ref_seq)
end
line = table.concat(concat_line, "?")
ref_seq = vim.tbl_flatten(tbl_seq)

@variables+=
local print_count = 0

@define_functions+=
function get_valid(tail, seq, seq_index, mem, min_len)
	@trim_to_first_block
	@current_memoization_state
	@skip_if_memoized

	@if_done_with_seq_index_return
	@prune_if_too_big_hashes
	@prune_if_too_short_for_min_len
	@check_if_sequence_are_removed
	@search_for_next_interrogation_mark
	@if_none_check_validity

	@replace_interrogation_mark_next

	@recurse_on_possible_replacements

	@memoize_current
	return valid
end

@trim_to_first_block+=
if #tail > 0 then
	local n,_ = tail:find("[#?]")
	if n then
		tail = tail:sub(n)
	else
		tail = ""
	end
end

@check_if_sequence_are_removed+=
while seq_index <= #seq and #tail > 0 and tail:sub(1,1) == "#" do
	@skip_if_memoized
	local m1,_ = tail:find("#%.")
	local m2,_ = tail:find("#$")
	local m3,_ = tail:find("#%?")
	local m = m1 or m2

	if not m then
		break
	end

	if m3 and m3 < m then
		if m3 > seq[seq_index] then
			local valid = 0
			@memoize_current_now
			return 0
		end
		break
	end

	if seq[seq_index] == m then
		seq_index = seq_index + 1
		tail = tail:sub(m+1)
		@trim_to_first_block
	else
		local valid = 0
		@memoize_current_now
		return valid
	end
end

@search_for_next_interrogation_mark+=
local n = tail:find("?")

@if_none_check_validity+=
if not n then
	if seq_index > #seq and #tail == 0 then
		return 1
	else
		return 0
	end
end

@if_done_with_seq_index_return+=
if seq_index > #seq then
	local valid = tail:find("#") and 0 or 1
	@memoize_current_now
	return valid
end

@replace_interrogation_mark_next+=
local tail_point = tail:sub(1,n-1) .. "." .. tail:sub(n+1)
local tail_hash = tail:sub(1,n-1) .. "#" .. tail:sub(n+1)

@recurse_on_possible_replacements+=
local valid = 0
valid = valid + get_valid(tail_point, seq, seq_index, mem, min_len)
valid = valid + get_valid(tail_hash, seq, seq_index, mem, min_len)

@compute_poss_with_dp+=
local mem = {}
local valid = get_valid(line, ref_seq, 1, mem, min_len)

@current_memoization_state+=
local copy_tail = tail
local save_index = seq_index

@skip_if_memoized+=
if mem[tail] and mem[tail][seq_index] then
	return mem[tail][seq_index]
end

@memoize_current+=
mem[copy_tail] = mem[copy_tail] or {}
mem[copy_tail][save_index] = mem[copy_tail][save_index] or valid

@memoize_current_now+=
mem[tail] = mem[tail] or {}
mem[tail][seq_index] = mem[tail][seq_index] or valid


@prune_if_too_big_hashes+=
local m = tail:find("[^#]") or #tail+1
m = m - 1
if seq[seq_index] and m > seq[seq_index] then
	local valid = 0
	@memoize_current_now
	return valid
end

@compute_accumulated_min_length+=
local min_len = { ref_seq[#ref_seq] }
for i=#ref_seq-1,1,-1 do
	table.insert(min_len, 1, min_len[1]+ref_seq[i]+1)
end

@prune_if_too_short_for_min_len+=
if min_len[seq_index] and #tail < min_len[seq_index] then
	local valid = 0
	@memoize_current_now
	return valid
end


