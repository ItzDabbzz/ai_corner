# Object-Oriented Patterns

Lua has no native classes. OOP is implemented using tables and metatables.

## Basic Class Pattern

Example:

  local Player = { health = 100 }
  Player.__index = Player

  function Player.new(name)
      local p = setmetatable({}, Player)
      p.name = name
      return p
  end

  function Player:getHealth()
      return self.health
  end

  function Player:takeDamage(amount)
      self.health = math.max(0, self.health - amount)
  end

Usage:

  local player = Player.new("Alex")
  player:takeDamage(30)
  print(player:getHealth())  -- 70

## Inheritance Pattern

Example:

  local AdminPlayer = {}
  AdminPlayer.__index = AdminPlayer

  function AdminPlayer.new(name)
      local p = Player.new(name)
      setmetatable(p, AdminPlayer)
      p.isAdmin = true
      return p
  end

  function AdminPlayer:kickPlayer(id)
      -- admin-only logic
  end

## Static Methods

Use the class table directly.

Example:

  function Player.spawnAll()
      -- logic for spawning all players
  end

## When to Use OOP

- Use object-style patterns when:
  - You have multiple entities sharing structure and behavior (players, vehicles, zones).
  - It improves clarity and organization.

- Avoid overusing OOP:
  - For small scripts, simple functions and tables are better.
