local x = 1

do
  local x = 2
  assert(x == 2)
end

assert(x == 1)

local a, b = 1, 2
local function f()
  local a = 9
  return a, b
end

local fa, fb = f()
assert(fa == 9 and fb == 2)
assert(a == 1)
