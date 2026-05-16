# Modules and require (FiveM-specific)

## High-level

- FiveM uses a modified require system.
- It is NOT a standard Lua 5.4 package manager.
- Don’t rely on package.path, package.cpath, or package.preload.
- Treat require as a per-resource module loader provided by FiveM.

## Basic require pattern

- Used to load other .lua files in the same resource.
- File must be declared in fxmanifest (e.g., as a client_script or shared_script), or be loadable via FiveM’s runtime rules.

Example structure:

  fxmanifest.lua:
    fx_version = 'cerulean'
    game = 'gta5'

    client_scripts = {
      'client.lua',
      'modules/players.lua'
    }

  client.lua:
    local players = require('modules.players')

  modules/players.lua:
    local M = {}

    function M.getAllPlayers()
        return {1, 2, 3}
    end

    return M

## Important rules

- require paths:
  - Use relative paths inside the resource.
  - Do not use cross-resource requires.
- Modules must return their public API (a table).
- Keep modules small and single-responsibility.

## No package.path semantics

- Do not:
  - Customize package.path
  - Rely on LuaRocks or external packages
- FiveM controls the loader; unexpected modifications can break scripts.

## Safe patterns

- Use require for:
  - Utility libraries inside a resource
  - Shared logic between client/server files of the same resource
- Avoid exposing internal implementation details; return only the API table.

Example:

  local Config = {
      Debug = true,
      MaxPlayers = 100
  }

  local function internalHelper()
      -- private
  end

  return {
      GetConfig = function()
          return Config
      end
  }
