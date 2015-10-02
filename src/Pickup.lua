-- base class for pickup --
local Pools = require("src.effectsPool")
local TexMate = require("texmate.TexMate")
local world = require('src.world')
local Pickup = class('Pickup')
local TexMateStatic = require("texmate.TexMateStatic")
Pickup:include(require('stateful'))

function Pickup:initialize()
  self.frame = TexMateStatic(PROTOTYPEASSETS,"rockDirt.png",0,0,65,123)
  self.collision = world:newCircleCollider(300, 300, 50)
  self.collision.body:setFixedRotation(true)
  self.collision.fixtures['main']:setRestitution(0.3)
  self.collision.body:applyLinearImpulse(100,0,self.collision.body:getX()-30,self.collision.body:getY()-30)
end

function Pickup:update(dt)
  self.frame:changeLoc(self.collision.body:getX(),self.collision.body:getY())
  self.frame:changeRot(math.deg(self.collision.body:getAngle()))
end

function Pickup:draw()
  self.frame:draw()
end

return Pickup
