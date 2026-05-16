# Errors and Defensive Coding

## Use assert over if-then-error

Prefer assert for concise preconditions.

BAD:
  - if not someVar then error("someVar is nil") end

GOOD:
  - assert(someVar ~= nil, "someVar is nil")

## Precondition Checks

- Before important operations, list assumptions and validate them.
- Examples:
  - player objects not nil
  - required fields (money, inventory, etc.)
  - numeric parameters within expected range

BAD:
  - if not isPlayerDead() then return end

GOOD:
  - assert(isPlayerDead(), "player is not dead")

## Fail Loudly vs Silently

- For unexpected or impossible states: fail loudly with error/assert.
- For expected/recoverable states: log, then continue or return gracefully.

Example (expected/recoverable):
  - player selling items: if some fail, print/log which ones, let others proceed.

## pcall and xpcall

- pcall wraps a function call; returns (success, result) or (success, errorMsg).
- xpcall is like pcall but with an error handler.

Example:

  local success, result = pcall(function()
      return riskyFunction()
  end)

  if not success then
      print("Error:", result)
  end

Use pcall/xpcall for:
  - calls to external resources
  - loading/untrusted configs
  - experimental logic

## Assertions vs Errors as Values

- Use assertions for "should never happen" (internal invariants).
- Use error-as-value for expected failures that callers must handle.

Example:

  ---@return number|nil amount, table|nil error
  function add(a, b)
      if not a or not b then
          return nil, {
              code = "missing_required_params",
              message = "either a or b is nil"
          }
      end
      return a + b
  end

## Defensive Patterns for FiveM

- Always validate event parameters (types, ranges, not nil).
- Always check player/exports/objects before use.
- Prefer early return for invalid input.

Example:

  local function handleBuy(playerId, itemId, quantity)
      if not playerId or not itemId or not quantity then return end
      if type(quantity) ~= "number" or quantity <= 0 then return end

      local player = getPlayer(playerId)
      if not player then return end

      -- continue
  end

## Logging

- Use print() for quick logs; integrate with custom logging utilities when present.
- Log enough to debug without spamming.
- Include resource name prefix: "[MY_RESOURCE] message".
