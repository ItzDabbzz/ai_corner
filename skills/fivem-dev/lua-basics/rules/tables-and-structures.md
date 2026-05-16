# Tables and Structures

## Basics

- Tables are the central data structure in Lua.
- They support:
  - Arrays (1-based numeric indices)
  - Maps/dictionaries (any key)
  - Sets (keys with no values)

## Array Syntax

- Prefer implicit indices for simple arrays.

Bad:
  - local t = { [1] = "a", [2] = "b" }

Good:
  - local t = { "a", "b" }

## Accessing Fields

- Use . for known string keys.
- Use [] for dynamic keys.

Good:
  - local boss = company.boss

## Table Performance

- table.insert and table.remove are relatively slow for large arrays.
- For appending at end, use: t[#t + 1] = value
- For removing last, use: t[#t] = nil

## Length Operator

- #t returns the length for arrays.
- Do not use # on tables with gaps or mixed indices; behavior is undefined.

## Iteration

- ipairs: for ordered numeric arrays.
- pairs: for all key-value pairs (unordered).

Good:
  - for i, v in ipairs(arr) do end
  - for k, v in pairs(map) do end

## Avoid table.insert at Specific Index

- Prefer shifting manually or using separate lists if you need frequent middle inserts.

## Use Local Cache for Repeated Access

- Cache repeated table accesses in locals for performance and readability.

Bad:
  - local x = playerData.money + playerData.money

Good:
  - local money = playerData.money
    local x = money + money
