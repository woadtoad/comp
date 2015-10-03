-- base class for pickup --
local Pools = require("src.Pool")
local TexMate = require("texmate.TexMate")
local WorldManager = require('src.WorldManager')
local Pickup = class('Pickup')
local TexMateStatic = require("texmate.TexMateStatic")
Pickup:include(require('stateful'))

local isActive

function Pickup:initialize(x,y)
  x = x or 300
  y = y or 300
  foodOffsetX = 130
  foodOffsetY = 140
  shadowOffsetX = 275
  shadowOffsetY = 215
  foodScale = .4
  self.frames = {TexMateStatic(TEAMASSETS,"food/Item_0000",0,0,foodOffsetX,foodOffsetY,0,false,foodScale,foodScale),
                TexMateStatic(TEAMASSETS,"food/Item_0001",0,0,foodOffsetX,foodOffsetY,0,false,foodScale,foodScale),
                TexMateStatic(TEAMASSETS,"food/Item_0002",0,0,foodOffsetX,foodOffsetY,0,false,foodScale,foodScale)}
  self.shadow = TexMateStatic(TEAMASSETS,"mockup_toad_new/Shadow_0000",0,0,shadowOffsetX,shadowOffsetY,0,false,foodScale,foodScale)
  self.food = love.math.random(1,3)
  self.collider = WorldManager.world:newCircleCollider(x, y, 15, {collision_class='Pickup'})
  self.collider.body:setFixedRotation(true)
  self.collider.body:setLinearDamping(1.5)
  self.collider.fixtures['main']:setRestitution(0.3)
  isActive = true
end

function Pickup:update(dt)
  self.frames[self.food]:changeLoc(self.collider.body:getX(),self.collider.body:getY())
  self.frames[self.food]:changeRot(math.deg(self.collider.body:getAngle()))
  self.shadow:changeLoc(self.collider.body:getX(),self.collider.body:getY())
  self.shadow:changeRot(math.deg(self.collider.body:getAngle()))
 --[[ if self.collider:enter('Player') then
      --player collision logic here
  end
  if self.collider:enter('Base') then
      print("base hit")
  end]]
end

function Pickup:draw()
  if isActive then
    self.shadow:draw()
    self.frames[self.food]:draw()
  end
end

function Pickup:makeActive(x,y)
  self.collider.body:setPosition(x,y)
  self.collider.body:setActive(true)
  isActive = true
end

function Pickup:deactivate()
  self.collider.body:setActive(false)
  isActive = false
end

return Pickup
