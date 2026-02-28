assert(123 == 123)
assert(0xFF == 255)
assert(0X10 == 16)
assert(tonumber("3.14") == nil)
assert(tonumber("1e5") == nil)
assert("\u{41}" == "A")

local s = "a\z  \n\tb"
assert(s == "a\n\tb")
assert(string.len("\u{10FFFF}") > 0)
