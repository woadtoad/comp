local SceneManager = require('src.SceneManager')
local SCENES = require('src.config.SCENES')
local Camera = require('src.Camera')
local Player = require('src.Player')
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

  end

  function EndScene:update(dt)

  end

  function EndScene:draw()
    Camera.parent:draw(
    function(l, t, w, h)

    end
    )
  end

  function EndScene:ddraw()
    Camera.parent:draw(
    function(l, t, w, h)

    end
    )
  end

  function EndScene:input(input)

  end

  function EndScene:destroy()
  end

end
