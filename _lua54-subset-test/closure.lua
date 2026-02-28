local function counter(start)
  local n = start
  return function(step)
    n = n + step
    return n
  end
end

local c = counter(10)
assert(c(1) == 11)
assert(c(5) == 16)
