local SceneManager = require('src.SceneManager')
local SCENES = require('src.config.SCENES')
local Camera = require('src.Camera')
local Player = require('src.Player')
local Sounds = require('src.Sound')
local Text = require('src.Text')
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
    Sounds.loop({SOUNDS.MENU_DRUMS})
  end

  function PauseScene:update(dt)

  end

  function PauseScene:draw()
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

    love.graphics.setColor(20, 90, 40, 180)
    love.graphics.rectangle('fill', l, t, l+w, l+h)

    love.graphics.setColor(255, 255, 255, 255)
    Text.huge('PAUSE SCREEN', (l+w) / 2 - (limit / 2), yStart, limit, 'center')
    Text.huge('START to unpause', (l+w) / 2 - (limit / 2), yStart + 200, limit, 'center')
    Text.huge('BACK for new game', (l+w) / 2 - (limit / 2), yStart + 250, limit, 'center')
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
    for id,isPlaying in pairs(self.joinedPlayers) do
      if isPlaying then
        -- Pause the game!
        if input:pressed(INPUTS.UNPAUSE, id) then
          print('Player ' .. id .. ' unpaused the game')
          self:popState()
        end
        -- Restart the game!
        if input:pressed(INPUTS.RESTART, id) then
          print('Player ' .. id .. ' restart the game')
          self:gotoState(SCENES.START)
        end
      end
    end
  end

  function PauseScene:destroy()
  end

end
