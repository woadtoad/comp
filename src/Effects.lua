
local Effects = class('Effects')
Effects:include(require('libs.stateful'))
local TexMate = require("libs.texmate.TexMate")
local Pools = require("src.Pool")

function  Effects:initialize()

  self.AnimList = {}

  self.AnimList["Splash"] = {
    framerate = 10,
    frames = {TexMate:frameCounter("spash/Splash_",0,8,4)
    }
  }


  self.Pool = Pools:new(TexMate,30,TEAMASSETS,self.AnimList,"Splash",nil,nil,0,-30)

end

function Effects:makeEffect(name,x,y)

    if name == "Splash" then
      local effect = self.Pool:makeActive()

      effect.endCallback[name] = function() self.Pool:deactivate(effect.key) end
      effect:changeAnim(name)
      effect.offset.x = 0
      effect.offset.y = -20
      effect:changeLoc(x,y)

    end

end

function Effects:draw()
  self.Pool:draw()
end

function Effects:update(dt)
  self.Pool:update(dt)
end

return Effects:new()
