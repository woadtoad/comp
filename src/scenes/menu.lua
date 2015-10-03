local SceneManager = require('src.SceneManager')
local SCENES = require('src.config.SCENES')

return function(MenuScene)
  function MenuScene:initialize()
    --self.button = UI.Button(10, 10, 90, 90)
    self.P1 = "Player 1"
    self.P2 = "Player 2"
    self.P3 = "Player 3"
    self.P4 = "Player 4"
    self.P1Active = false
    self.P2Active = true
    self.P3Active = false
    self.P4Active = true

    self.font = love.graphics.newFont(70)
  end

  function MenuScene:update(dt)
   -- self.button:update(dt)

    -- buttons have a bool
   -- if self.button.pressed then
   --   SceneManager:gotoState(SCENES.GAME)
   -- end

  end

  local thirdw =  love.window.getWidth() / 3
  local thirdh = love.window.getWidth() / 3

  function MenuScene:draw()
    --chatbox:draw()
    --self.button:draw()
      love.graphics.setFont(self.font)

        love.graphics.setColor(0,0,0,255)
        love.graphics.print("Press A to get ready",500,400)



      if  self.P1Active == true then
        love.graphics.setColor(80,255,100,255)
        love.graphics.print(self.P1,300,500)
      else
        love.graphics.setColor(80,100,100,255)
        love.graphics.print(self.P1,300,500)
      end

      if  self.P2Active == true then
        love.graphics.setColor(80,255,100,255)
        love.graphics.print(self.P2,600,500)
      else
        love.graphics.setColor(80,100,100,255)
        love.graphics.print(self.P2,600,500)
      end

      if  self.P3Active == true then
        love.graphics.setColor(80,255,100,255)
        love.graphics.print(self.P3,300,200)
      else
        love.graphics.setColor(80,100,100,255)
        love.graphics.print(self.P3,300,200)
      end

      if  self.P4Active == true then
        love.graphics.setColor(80,255,100,255)
        love.graphics.print(self.P4,600,200)
      else
        love.graphics.setColor(80,100,100,255)
        love.graphics.print(self.P4,600,200)
      end

      love.graphics.setColor(255,255,255,255) --Add this line to put colour back to white
  end

  function MenuScene:keypressed(key, isrepeat)
    if key == "g" then
      SceneManager:gotoState(SCENES.GAME)
    else
      SceneManager:gotoState(SCENES.MENU)
    end
  end
end
