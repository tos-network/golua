local t = {a = 1, b = 2}
assert(type(_G) == "table")
assert(type(_VERSION) == "string")
assert(type(assert) == "function")
assert(type(tostring(t)) == "string")
assert(tonumber("0x10") == 16)
assert(tonumber("3.14") == nil)
