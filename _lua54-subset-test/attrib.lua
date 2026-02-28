local closed = 0

do
  local obj <close> = setmetatable({}, {
    __close = function()
      closed = closed + 1
    end,
  })
  local x <const> = 7
  assert(x == 7)
end

assert(closed == 1)
