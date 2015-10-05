local SceneManager = require('src.SceneManager')
local SCENES = require('src.config.SCENES')
local Camera = require('src.Camera')
local Player = require('src.Player')
local Text = require('src.Text')
local Sounds = require('src.Sound')
local PlayerBase = require('src.PlayerBase')

return function(EndScene)

  function EndScene:initialize()
    print('  EndScene:initialize')
    if self.initialized then
      return
    end

    self.initialized = true
  end

  function EndScene:enteredState()
    print('  EndScene:enteredState')
    self:initialize()
    self:reset()
  end

  function EndScene:exitedState()
    print('  EndScene:exitedState')
    self:destroy()
  end

  function EndScene:pausedState()
    print('  EndScene:pausedState')
  end

  function EndScene:continuedState()
    print('  EndScene:continuedState')
    self:destroy()
    self:reset()
  end

  function EndScene:reset()
    Sounds.loop({SOUNDS.END})
  end

  function EndScene:update(dt)

  end

  function EndScene:draw()
    Camera.parent:draw(
    function(l, t, w, h)
      for i, v in pairs(self.drawList) do
        self.drawList[i]:draw()
      end
    end
    )

    local l = 0
    local t = 0
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    local limit = 500
    local yStart = 100

    love.graphics.setColor(20, 20, 20, 180)
    love.graphics.rectangle('fill', l, t, w, h)

    love.graphics.setColor(255, 255, 255, 255)
    Text.huge('END SCENE', (l+w) / 2 - (limit / 2), yStart, limit, 'center')

    local smh = 50 + 20
    for i=1,#self.bases do
      Text.huge('PLAYER ' .. i .. ': ' .. self.bases[i]:getcurrentPoints(), (l+w) / 2 - (limit / 2), yStart + 200 + (i - 1)*50, limit, 'center')
    end

    Text.huge('START to new game', (l+w) / 2 - (limit / 2), yStart + 300 + #self.bases*20, limit, 'center')
  end

  function EndScene:ddraw()
    Camera.parent:draw(
    function(l, t, w, h)

    end
    )
  end

  function EndScene:keypressed(key, isrepeat)
    if key =="e" then
      self:popState()
    end
  end

  function EndScene:input(input)
    for k,player in pairs(self.players) do
      -- Pause the game!
      if input:pressed(INPUTS.NEW_GAME, player.id) then
        print('Player ' .. player.id .. ' unpaused the game')
        self:gotoState(SCENES.GAME)
      end
    end
  end

  function EndScene:destroy()
  end

end
