-- base class for pickup --
local Pools = require("src.effectsPool")
local TexMate = require("texmate.TexMate")
local world = require('src.world')
local Pickup = class('Pickup')
local TexMateStatic = require("texmate.TexMateStatic")
Pickup:include(require('stateful'))

function Pickup:initialize()
  self.frame = TexMateStatic(PROTOTYPEASSETS,"rockDirt.png")
  self.collision = world:newRectangleCollider(300, 300, 50, 50, {collision_class = 'Player'})
  self.collision.body:setFixedRotation(false)
  self.collision.fixtures['main']:setRestitution(0.3)
  self.collision.body:applyLinearImpulse(100,0,self.collision.body:getX()-30,self.collision.body:getY()-30)
end

function Pickup:update(dt)

  self.collision.body:applyLinearImpulse(500, 0)
end

function Pickup:draw()
  self.frame:draw()
end

return Pickup