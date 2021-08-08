-- This is fine as relative, although that isn't mentioned in the docs
local gamecontrollerdb_path = 'src/config/gamecontrollerdb/gamecontrollerdb.txt'
local customdb_path = 'src/config/gamecontrollerdb/customdb.txt'

if love.filesystem.exists(gamecontrollerdb_path) and love.filesystem.exists(customdb_path) then
  print('  Initializing gamepad mappings...')
  local loaded = love.joystick.loadGamepadMappings(gamecontrollerdb_path)
  local loaded = love.joystick.loadGamepadMappings(customdb_path)
  if loaded == false then
    print('    Failed')
  end
end

local Input = require('libs.boipushy.Input')

local input = Input()

-- Input is a singleton
return input
