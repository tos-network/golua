local max = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
assert((max >> 255) == 1)
assert((1 << 255) + (1 << 255) == 0)
assert((max + max) == (max - 1))
assert((2 ^ 255) == (1 << 255))
