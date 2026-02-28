local t = {5, 1, 3, 2, 4}
table.sort(t)
assert(table.concat(t, ",") == "1,2,3,4,5")

table.sort(t, function(a, b)
  return a > b
end)
assert(table.concat(t, ",") == "5,4,3,2,1")
