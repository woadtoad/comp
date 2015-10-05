local SceneManager = require('src.SceneManager')
local SCENES = require('src.config.SCENES')
local Camera = require('src.Camera')
local Player = require('src.Player')
local Sounds = require('src.Sound')
local Text = require('src.Text')
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
    Sounds.loop({SOUNDS.INTRO})
  end

  function StartScene:update(dt)

  end

  function StartScene:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local limit = 300
    local yStart = 100

    love.graphics.setColor(20, 120, 20, 120)
    love.graphics.rectangle('fill', 0, 0, w, h)

    love.graphics.setColor(255, 255, 255, 255)
    Text.huge('START SCREEN', w / 2 - (limit / 2), yStart, limit, 'center')
    Text.huge('A to join', w / 2 - (limit / 2), yStart + 200, limit, 'center')
    Text.huge('START to start', w / 2 - (limit / 2), yStart + 250, limit, 'center')

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

  function StartScene:keypressed(key, isrepeat)
    --Start the game, lel
    if key == " " then
      self:pushState(SCENES.GAME)
    end
  end

  function StartScene:input(input)
    for k,joystick in pairs(love.joystick.getJoysticks()) do
      -- Join the game!
      if input:pressed(INPUTS.JOIN, joystick:getID()) then
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
