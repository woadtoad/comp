
local Effects = class('Effects')
Effects:include(require('stateful'))
local TexMate = require("texmate.TexMate")
local Pools = require("src.Pool")

function  Effects:initialize()

  self.arrowAnimList = {}

  self.arrowAnimList["Explosion"] = {
    framerate = 10,
    frames = {TexMate:frameCounter("Explosion",1,13,3,".png")
    }
  }

  self.Pool = Pools:new(TexMate,30,PROTOTYPEASSETS,self.arrowAnimList,"Explosion",nil,nil,0,-30)

end

function Effects:makeEffect(name,pivotx,pivoty,x,y)
    effect = self.Pool:makeActive()

    effect.endCallback[name] = function() self.Pool:deactivate(effect.key) end
    effect:changeAnim(name)
    effect.offset.x = pivotx or 0
    effect.offset.y = pivoty or 0
    effect:changeLoc(x,y)

end

function Effects:draw()
  self.Pool:draw()
end

function Effects:update(dt)
  self.Pool:update(dt)
end

return Effects
