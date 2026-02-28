local t = {a = 1, b = 2, c = 3}
local n, s = 0, 0
for _, v in pairs(t) do
  n = n + 1
  s = s + v
end
assert(n == 3 and s == 6)

local arr = {4, 5, 6}
local ni, si = 0, 0
for i, v in ipairs(arr) do
  ni = ni + 1
  si = si + v
  assert(i == ni)
end
assert(ni == 3 and si == 15)

local k, v = next(arr, nil)
assert(k == 1 and v == 4)
