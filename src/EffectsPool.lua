local TexMate = require("texmate.TexMate")
local theEffects = {}
local EffectsPool = class('effectsPool')

function EffectsPool:initialize()
  animlist = {TexMate:frameCounter("Explosion",1,26,3,".png")}
  self.sprite = TexMate:new(PROTOTYPEASSETS,explosion)
  self.addEffect("explosion",self.sprite)
  self.activeEffects = {self.sprite}
end

function EffectsPool:draw()

  for i,v in pairs(self.activeEffects) do
    self.activeEffects[v.key]:draw()
  end
end

function EffectsPool:update(dt)

  for i,v in pairs(self.activeEffects) do
    self.activeEffects[v.key]:update(dt)
  end

end

function EffectsPool:addEffect(name, effect)

  theEffects[name] = effect
end

function EffectsPool:removeEffect()

end

function EffectsPool:playEffectPos(effect,x,y)

end

function EffectsPool:playEffectObj(effect,obj)

end

return EffectsPool
