local t = {}
rawset(t, "k", 9)
assert(rawget(t, "k") == 9)
assert(rawequal(rawget(t, "k"), 9))

local ok, err = pcall(function()
  error("boom")
end)
assert(ok == false)
assert(string.find(tostring(err), "boom", 1, true) ~= nil)

local ok2, err2 = xpcall(function()
  error("x")
end, function(e)
  return "handled:" .. tostring(e)
end)
assert(ok2 == false)
assert(string.find(tostring(err2), "handled:", 1, true) ~= nil)
