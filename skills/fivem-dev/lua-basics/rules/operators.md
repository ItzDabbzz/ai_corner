# Operators

## Arithmetic

- Addition: +
- Subtraction: -
- Multiplication: *
- Division: /
- Modulo: %
- Exponent: ^
- Integer division: //

Example:
- 7 / 2 = 3.5
- 7 // 2 = 3
- 7 % 3 = 1

## Concatenation

- Operator: ..
- Concatenates strings.

Example:
- local greeting = "Hello, " .. name .. "!"

## Relational

- Equal: ==
- Not equal: ~=
- Less than: <
- Greater than: >
- Less than or equal: <=
- Greater than or equal: >=

## Logical

- and
- or
- not

Short-circuit patterns:

- x or y: returns x if x is truthy, else y
- x and y: returns x if x is falsy, else y

Example:
- local value = input or "default"

## Precedence

High to low:

1. ^
2. not, # (length)
3. *, /, //, %
4. +, -
5. .. (concatenation)
6. <, >, <=, >=, ~=, ==
7. and
8. or

## Gotchas

- Tables are not value-equal: t1 == t2 is true only if they are the same table reference.
- NaN != NaN: any comparison with NaN returns false.
- Boolean logic is Lua-style: only nil and false are falsy.
