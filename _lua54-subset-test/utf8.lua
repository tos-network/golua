assert(utf8 == nil)

local s1 = "\u{41}\u{42}\u{43}"
assert(s1 == "ABC")

local s2 = "\u{4E2D}"
assert(string.len(s2) == 3)

local s3 = "\u{1F600}"
assert(string.len(s3) == 4)
