# Math and Bit32

## Math Library

Commonly used:

- math.abs(x)
- math.floor(x)
- math.ceil(x)
- math.min(a, b, ...)
- math.max(a, b, ...)
- math.random()
- math.random(m, n)
- math.sqrt(x)
- math.sin(x), math.cos(x), math.tan(x)
- math.rad(deg), math.deg(rad)

Useful for:

- Calculations of distances, speeds
- Angles and rotation helpers
- Random values for gameplay

## Bit32 Library

Bitwise operations on 32-bit integers.

Functions:

- bit32.band(x, y, ...)
- bit32.bor(x, y, ...)
- bit32.bnot(x)
- bit32.bxor(x, y, ...)
- bit32.lshift(x, n)
- bit32.rshift(x, n)
- bit32.arshift(x, n)
- bit32.extract(x, field [, width])
- bit32.replace(x, value, field, width)

Use cases in FiveM:

- Flag fields (permissions, options)
- Encoding/decoding composite values
- Working with bitfields from natives or configs

Example:

  local FLAGS_CAN_JUMP   = 1    -- 0b001
  local FLAGS_CAN_DASH   = 2    -- 0b010
  local FLAGS_CAN_SHOOT  = 4    -- 0b100

  local flags = 5  -- 0b101: jump + shoot

  local canJump = bit32.band(flags, FLAGS_CAN_JUMP) ~= 0

## Notes

- Math operations are standard Lua 5.4.
- No special sandboxing restrictions.
- Use bit32 instead of manual bit tricks when available.
