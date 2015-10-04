local SceneManager = require('src.SceneManager')
local SCENES = require('src.config.SCENES')
local Camera = require('src.Camera')
local Player = require('src.Player')
local PlayerBase = require('src.PlayerBase')

return function(StartScene)

  function StartScene:initialize()
    print('  StartScene:initialize')
    if self.initialized then
      return
    end

    love.graphics.setBackgroundColor( 100, 110, 200 )
    self.initialized = true
  end

  function StartScene:enteredState()
    print('  StartScene:enteredState')
    self:initialize()
    self:reset()
  end

  function StartScene:exitedState()
    print('  StartScene:exitedState')
    self:destroy()
  end

  function StartScene:pausedState()
    print('  StartScene:pausedState')
  end

  function StartScene:continuedState()
    print('  StartScene:continuedState')
    self:destroy()
    self:reset()
  end

  function StartScene:reset()

  end

  function StartScene:update(dt)

  end

  function StartScene:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()

    love.graphics.setColor(20, 120, 20, 120)
    love.graphics.rectangle('fill', 0, 0, w, h)

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('START SCREEN', w / 2 - (100 / 2), 50, 100, 'center')
    love.graphics.printf('A to join', w / 2 - (200 / 2), 100, 200, 'center')
    love.graphics.printf('START to start', w / 2 - (200 / 2), 120, 200, 'center')
    Camera.parent:draw(
    function(l, t, w, h)
    end
    )
  end

  function StartScene:ddraw()
    Camera.parent:draw(
    function(l, t, w, h)

    end
    )
  end

  function StartScene:keypressed()
  end

  function StartScene:input(input)
    for k,joystick in pairs(love.joystick.getJoysticks()) do
      -- Join the game!
      if input:pressed(INPUTS.JOIN) then
        print('Player ' .. joystick:getID() .. ' joined')
      end
    end

    -- Player 1 starts the game
    -- Start the game!
    if input:pressed(INPUTS.NEW_GAME) then
      self:pushState(SCENES.GAME)
    end
  end

  function StartScene:destroy()
  end

end
