##test
@test.lua=
require"BigNum"
local a = BigNum.new(1)
print(a)

local b = BigNum.new(1)
print(b)

local c = {}
c[a] = "hello"
print(c[a])
print(c[b])
