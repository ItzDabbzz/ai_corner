# Strings and Patterns

## Basic String Operations

- Use double or single quotes: "..." or '...'
- Escape with backslash: \n, \t, \\, \"
- Concatenate with ..:

  local fullName = firstName .. " " .. lastName

## String Library

Commonly used:

- string.len(s)
- string.sub(s, i, j)
- string.upper(s)
- string.lower(s)
- string.rep(s, n)
- string.format(fmt, ...)

Example:

  local msg = string.format("%s has %d health", name, health)

## Pattern Basics

Lua uses its own pattern syntax, not full regex.

Character classes:

- %a: letters
- %c: control characters
- %d: digits
- %l: lowercase letters
- %p: punctuation
- %s: space characters
- %u: uppercase letters
- %w: alphanumeric
- %x: hex digits
- %z: zero byte

- % (percent) escapes character classes: %% is a literal %.
- . (dot) matches any character (except \n in most contexts).

Quantifiers:

- +: one or more
- *: zero or more
- -?: minimal/shortest match
- ?: zero or one

Common patterns:

- "%d+"        - one or more digits
- "%w+"        - one or more word characters
- "%.+"        - any non-empty substring

## string.find

- Finds first match.
- Returns indices (start, end) or nil.

Example:

  local s, e = string.find(text, "%d+")

## string.match

- Returns the matched substring(s), or nil.

Example:

  local id = string.match("ID: 42", "ID: (%d+)")

## string.gsub

- Global substitution.
- string.gsub(s, pattern, repl, n)

Example:

  local censored = string.gsub(message, "%d+", "X")

## string.gmatch

- Returns an iterator over all matches.

Example:

  for word in string.gmatch(text, "%w+") do
      print(word)
  end

## Practical Use Cases

- Command parsing:
  - local _, _, cmd, arg = string.find(input, "^/(%S+)(%s*(.-))?$")
- ID/number extraction from messages
- Normalizing user input (trim, lower)
- Building formatted messages for chat/UI
