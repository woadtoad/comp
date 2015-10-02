-- base class for pickup --
local Pools = require("src.Pool")
local TexMate = require("texmate.TexMate")
local world = require('src.world')
local Pickup = class('Pickup')
local TexMateStatic = require("texmate.TexMateStatic")
Pickup:include(require('stateful'))

local isActive

function Pickup:initialize()
  self.frame = TexMateStatic(PROTOTYPEASSETS,"rockDirt.png",0,0,65,123)
  self.collider = world:newCircleCollider(300, 300, 50)
  self.collider.body:setFixedRotation(true)
  self.collider.fixtures['main']:setRestitution(0.3)
  self.collider.body:applyLinearImpulse(100,0,self.collider.body:getX()-30,self.collider.body:getY()-30)
  isActive = true
end

function Pickup:update(dt)
  self.frame:changeLoc(self.collider.body:getX(),self.collider.body:getY())
  self.frame:changeRot(math.deg(self.collider.body:getAngle()))
 --[[ if self.collider:enter('Player') then
      --player collision logic here
  end
  if self.collider:enter('Goal') then
      --goal collision logic here
  end]]--
end

function Pickup:draw()
  if isActive then
    self.frame:draw()
  end
end

function Pickup:makeActive(x,y)
  self.collider.body:setPosition(x,y)
  self.collider.body:setActive(true)
  isActive = true
end

function Pickup:deactivate()
  self.collider.body:setActive(false)
  isActive = true
end

return Pickup
