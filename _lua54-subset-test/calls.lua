local function sum(...)
  local s = 0
  for i = 1, select("#", ...) do
    s = s + select(i, ...)
  end
  return s
end
assert(sum(1, 2, 3, 4) == 10)

local t = {}
function t:add(a, b)
  return a + b
end
assert(t:add(3, 4) == 7)

local c = setmetatable({v = 9}, {
  __call = function(self, x)
    return self.v + x
  end,
})
assert(c(5) == 14)
