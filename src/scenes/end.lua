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
      for i, v in pairs(self.drawList) do
        self.drawList[i]:draw()
      end

      love.graphics.setColor(20, 20, 20, 180)
      love.graphics.rectangle('fill', l, t, w, h)

      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.printf('END SCENE', w / 2, h / 2, 100, 'center')
      for i=1,#self.bases do
        love.graphics.printf("Player "..i.." Score: "..self.bases[i]:getcurrentPoints(), w / 2, h/2 + (10*i), 200, 'center')
      end
    end
    )
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

  end

  function EndScene:destroy()
  end

end
