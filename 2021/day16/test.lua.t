##test
@test.lua=
local a = {}
vim.list_extend(a, {1, 2, 3})
vim.list_extend(a, {5, 6})
print(vim.inspect(a[1:4]))
