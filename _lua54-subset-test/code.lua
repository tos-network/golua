local x = 0
for i = 1, 10 do
  x = x + i
end
assert(x == 55)

local y = 0
if x > 50 then
  y = 1
else
  y = 2
end
assert(y == 1)
