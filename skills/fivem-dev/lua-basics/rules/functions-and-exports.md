# Functions and Exports

## General

- Functions should do one thing and be small. If not, break them up.
- Avoid mixing high-level orchestration with low-level details.

## Naming

- Local functions: camelCase.
- Global/exported functions: PascalCase.
- Always use a leading verb.

Bad:
  - player()
  - playerDrop()

Good:
  - getPlayerObject()
  - dropPlayer()

## Parameters

### Limit Parameters

- If a function needs more than ~3 parameters, group them into a table argument.

Bad:
  - createChar(name, age, height, birthday, nationality)

Good:
  - createChar(charData)

### Avoid Boolean Flags in APIs

- Boolean parameters suggest the function is doing two things. Split them.
- Applies especially to global/exported functions.

Bad:
  - function PrintEmotionalState(isHappy)

Good:
  - function PrintHappy()
  - function PrintSad()

### Avoid Inline Anonymous Functions

- Prefer naming functions and passing them by reference.
- Helps performance (no repeated allocations) and readability.

Bad:
  - someFunction(function() end)

Good:
  - local function myFunction() end
    someFunction(myFunction)

### Optional Parameters

- Required parameters before optional.
- Document optional parameters clearly.

## Multiple Return Values

- Lua supports multiple return values.
- Use them instead of packing into tables when appropriate.

Example:
  - local success, value = performOperation()

## Vararg Functions

- Use ... for functions that accept a variable number of arguments.
- Common for logging or wrappers.

Example:
  - local function log(...)
      print("[LOG]", ...)
    end

## Tail Calls

- Lua supports tail-call optimization.
- If a function’s last action is calling another function, use tail call.

Good:
  - function f(x)
      return g(x)
    end

## Export Documentation (LuaDoc)

- All exported functions should include LuaDoc annotations.

Example:
  - --- Formats a full name
    ---@param first string
    ---@param last string
    ---@return string fullName
    local function formatName(first, last)
        return first .. ' ' .. last
    end

    exports('formatName', formatName)

## Guard Clauses

- Use early returns to validate preconditions.
- Improves readability and reduces nesting.

Bad:
  - local function getFullName(first, last)
      if not nameHidden and first and last then
          return first .. last
      else
          return nil
      end
    end

Good:
  - local function getFullName(first, last)
      if nameHidden then return end
      if not first or not last then return end
      return first .. last
    end
