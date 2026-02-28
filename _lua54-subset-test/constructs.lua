local i, s = 0, 0
while i < 5 do
  i = i + 1
  if i == 3 then
    goto skip
  end
  s = s + i
  ::skip::
end
assert(s == 12)

repeat
  i = i - 1
until i == 0
assert(i == 0)
