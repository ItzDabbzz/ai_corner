# Metatables and Metamethods

## What Are Metatables?

- A metatable defines how a table behaves under certain operations.
- Used for:
  - Default field behavior
  - Custom operators
  - Object-like encapsulation

## __index

- Triggered when a key is not found.
- Can be:
  - A function(key)
  - A table used as fallback

Example (fallback table):

  local defaults = { speed = 100 }

  local t = { }
  setmetatable(t, { __index = defaults })

  print(t.speed)  -- 100

Example (function):

  local t = { }
  setmetatable(t, {
      __index = function(table, key)
          return "default for " .. key
      end
  })

  print(t.foo)  -- "default for foo"

## __newindex

- Triggered when assigning to a new key that doesn’t exist.
- Can be used to:
  - Validate keys
  - Prevent new keys
  - Redirect writes

Example:

  setmetatable(t, {
      __newindex = function(table, key, value)
          print("Setting new key: " .. tostring(key))
          rawset(table, key, value)
      end
  })

## __call

- Makes a table callable like a function.

Example:

  local adder = setmetatable({}, {
      __call = function(self, x, y)
          return x + y
      end
  })

  print(adder(2, 3))  -- 5

## __tostring

- Defines string representation of a table.

Example:

  local player = setmetatable({ name = "Alex" }, {
      __tostring = function(self)
          return "Player(" .. self.name .. ")"
      end
  })

  print(player)  -- "Player(Alex)"

## Arithmetic and Equality Metamethods

Commonly available:

- __add, __sub, __mul, __div, __mod, __pow
- __unm (negation)
- __eq, __lt, __le

Example:

  local v = setmetatable({ x = 1, y = 2 }, {
      __add = function(a, b)
          return { x = a.x + b.x, y = a.y + b.y }
      end
  })

## When to Use

- Use metatables when you need:
  - Encapsulation
  - Default behaviors
  - Custom operations

- Avoid them when:
  - Simple tables are enough
  - Performance or readability would suffer
