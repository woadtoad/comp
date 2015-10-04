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
      for i, v in pairs(self.drawList) do
        self.drawList[i]:draw()
      end

      love.graphics.setColor(20, 20, 20, 180)
      love.graphics.rectangle('fill', l, t, w, h)

      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.printf('PAUSED', w / 2, h / 2, 100, 'center')
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
    if key =="e" then
      self:popState()
    end
  end

  function PauseScene:input(input)

  end

  function PauseScene:destroy()
  end

end
