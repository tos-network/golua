local a, b, c = unpack({10, 20, 30})
assert(a == 10 and b == 20 and c == 30)

local function pack(...)
  return {n = select("#", ...), ...}
end

local p = pack(7, 8, nil, 10)
assert(p.n == 4)
assert(p[1] == 7 and p[2] == 8 and p[4] == 10)

assert(select("#", 1, nil, 3) == 3)
assert(select(2, 11, 22, 33) == 22)
