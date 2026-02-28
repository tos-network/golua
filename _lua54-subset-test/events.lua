local mt = {}
mt.__index = function(_, k)
  if k == "x" then
    return 9
  end
end
mt.__newindex = function(t, k, v)
  rawset(t, k, v + 1)
end
mt.__call = function(_, a, b)
  return a + b
end
mt.__add = function(a, b)
  return setmetatable({n = a.n + b.n}, mt)
end

local t = setmetatable({n = 1}, mt)
assert(t.x == 9)
t.y = 4
assert(rawget(t, "y") == 5)
assert(t(2, 3) == 5)

local u = setmetatable({n = 2}, mt)
local v = t + u
assert(v.n == 3)
