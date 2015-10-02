local SceneManager = require('src.SceneManager')
local SCENES = require('src.config.SCENES')

return function(MenuScene)
  function MenuScene:initialize()
    self.button = UI.Button(10, 10, 90, 90)
  end

  function MenuScene:update(dt)
    self.button:update(dt)

    -- buttons have a bool
    if self.button.pressed then
      SceneManager:gotoState(SCENES.GAME)
    end

  end

  function MenuScene:draw()
    --chatbox:draw()
    self.button:draw()
  end

  function MenuScene:keypressed(key, isrepeat)
    if key == "g" then
      SceneManager:gotoState(SCENES.GAME)
    else
      SceneManager:gotoState(SCENES.MENU)
    end
  end
end
