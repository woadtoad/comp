local SceneManager = require('src.SceneManager')
local SCENES = require('src.config.SCENES')
local Camera = require('src.Camera')
local Player = require('src.Player')
local PlayerBase = require('src.PlayerBase')

return function(PauseScene)

  function PauseScene:initialize()
    print('  PauseScene:initialize')
    if self.initialized then
      return
    end

    self.initialized = true
  end

  function PauseScene:enteredState()
    print('  PauseScene:enteredState')
    self:initialize()
    self:reset()
  end

  function PauseScene:exitedState()
    print('  PauseScene:exitedState')
    self:destroy()
  end

  function PauseScene:pausedState()
    print('  PauseScene:pausedState')
  end

  function PauseScene:continuedState()
    print('  PauseScene:continuedState')
    self:destroy()
    self:reset()
  end

  function PauseScene:reset()

  end

  function PauseScene:update(dt)

  end

  function PauseScene:draw()
    Camera.parent:draw(
    function(l, t, w, h)
      -- local w, h = love.graphics.getWidth(), love.graphics.getHeight()

      love.graphics.setColor(20, 120, 20, 80)
      love.graphics.rectangle('fill', l, t, l+w, l+h)

      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.setDefaultFilter( 'nearest', 'nearest' )
      love.graphics.printf('PAUSE SCREEN', (l+w) / 2 - (100 / 2), 50, t + 100, 'center')
      love.graphics.printf('START to unpause', (l+w) / 2 - (200 / 2), t + 100, 200, 'center')
      love.graphics.printf('BACK for new game', (l+w) / 2 - (200 / 2), t + 120, 200, 'center')
    end
    )
  end

  function PauseScene:ddraw()
    Camera.parent:draw(
    function(l, t, w, h)

    end
    )
  end

  function PauseScene:keypressed(key, isrepeat)
  end

  function PauseScene:input(input)
    for k,joystick in pairs(love.joystick.getJoysticks()) do
      -- Pause the game!
      if input:pressed(INPUTS.UNPAUSE) then
        print('Player ' .. joystick:getID() .. ' unpaused the game')
        self:popState()
      end
      -- Restart the game!
      if input:pressed(INPUTS.RESTART) then
        print('Player ' .. joystick:getID() .. ' restart the game')
        self:gotoState(SCENES.START)
      end
    end
  end

  function PauseScene:destroy()
  end

end
