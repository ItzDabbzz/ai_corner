# Control Structures

## If Statements

```lua
if condition then
    -- do something
elseif otherCondition then
    -- do something else
else
    -- fallback
end
```

- Use early returns when possible.
- Prefer `not condition` over checking for a value when logic is clear.

Example (BAD):

```lua
if player then
    if player.active then
        doSomething(player)
    end
end
```

Example (GOOD):

```lua
if not player then return end
if not player.active then return end
doSomething(player)
```

## While Loops

```lua
while condition do
    -- body
end
```

- Use for simple repeating logic.
- Be careful with infinite loops; use `break` to exit.

## Repeat-Until

```lua
repeat
    -- body
until condition
```

- Guarantees the body runs at least once.
- The condition is checked after each iteration.

## Numeric For

```lua
for i = 1, 10 do
    -- body
end
```

- Inclusive range.
- Default step is 1.
- Use for simple counting loops.

## Generic For

- Use for iterating tables.

Using ipairs (ordered):

```lua
for i, value in ipairs(myArray) do
    -- i is numeric index, value is the element
end
```

Using pairs (unordered):

```lua
for key, value in pairs(myTable) do
    -- key is any type, value is the element
end
```

## Multiple Assignments

Lua supports multiple assignments:

```lua
local a, b, c = 1, 2, 3
```

Useful for swapping:

```lua
local x, y = 10, 20
x, y = y, x
```

Useful for destructuring returns:

```lua
local success, result = pcall(function() return 42 end)
```

## Break

- Used to exit loops.
- Only exits the innermost loop.
