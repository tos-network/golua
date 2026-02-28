local function f(...)
  return select("#", ...), ...
end

local n, a, b, c = f(1, 2, 3)
assert(n == 3 and a == 1 and b == 2 and c == 3)

local function sum(...)
  local s = 0
  for i = 1, select("#", ...) do
    s = s + select(i, ...)
  end
  return s
end

assert(sum(4, 5, 6) == 15)
