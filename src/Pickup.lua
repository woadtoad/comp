-- base class for pickup --
local Pools = require("src.Pool")
local TexMate = require("texmate.TexMate")
local WorldManager = require('src.WorldManager')
local Pickup = class('Pickup')
local TexMateStatic = require("texmate.TexMateStatic")
Pickup:include(require('stateful'))
local Vector = require('hump.vector')
local Effects = require('src.Effects')

local MAX_SPAWN_HEIGHT = 50

function Pickup:initialize(x,y)
  x = x or 300
  y = y or 300
  self.foodOffsetX = 130
  self.foodOffsetY = 130
  self.shadowOffsetX = 275
  self.shadowOffsetY = 215
  self.foodScale = 0.6
  self.spawningFrames = {
    Spawning = {
      framerate = 14,
      frames = {
        "food/Droplet_0000"
      }
    },
    Bursting = {
      framerate = 14,
      frames = {
        TexMate:frameCounter("food/Droplet_",0,3,4)
      }
    }
  }
  self.sprite = TexMate:new(TEAMASSETS, self.spawningFrames, "Spawning" , 0, 0, 0, 0, 0, false, self.foodScale * 1.2, self.foodScale * 1.2)

  self.sprite.endCallback['Bursting'] = function()
    self:gotoState('Active')
    self.sprite:pause()
  end

  self.frames = {
    TexMateStatic(TEAMASSETS,"food/Chicken_0000",0,0,self.foodOffsetX,self.foodOffsetY,0,false,self.foodScale,self.foodScale),
    TexMateStatic(TEAMASSETS,"food/Ham_0001",0,0,self.foodOffsetX,self.foodOffsetY,0,false,self.foodScale,self.foodScale),
    TexMateStatic(TEAMASSETS,"food/Ribs_0002",0,0,self.foodOffsetX,self.foodOffsetY,0,false,self.foodScale,self.foodScale)
  }
  self.shadow = TexMateStatic(TEAMASSETS,"mockup_toad_new/Shadow_0000",0,0,self.shadowOffsetX,self.shadowOffsetY,0,false,self.foodScale,self.foodScale)

  self.food = love.math.random(1,3)
  self.collider = WorldManager.world:newCircleCollider(x, y, 30, {collision_class='Pickup'})
  self.collider.body:setFixedRotation(true)
  self.collider.parent = self
  self.collider.body:setLinearDamping(1.5)
  self.collider.fixtures['main']:setRestitution(0.3)
  self.isActive = true
  self.activeScale = 0.25

  self.spawnDropHeight = MAX_SPAWN_HEIGHT

  self:gotoState('Spawning')
end

function Pickup:update(dt)
  self.frames[self.food]:changeLoc(self.collider.body:getX(),self.collider.body:getY())
  self.frames[self.food]:changeRot(math.deg(self.collider.body:getAngle()))
  self.shadow:changeLoc(self.collider.body:getX(),self.collider.body:getY())
  self.shadow:changeRot(math.deg(self.collider.body:getAngle()))
 --[[ if self.collider:enter('Player') then
      --player collision logic here
  end
  ]]
  if self.collider:enter('Base') then
      self.collider.body:setLinearDamping(5)
  end
  if self.collider:enter('Base') then
    self.collider.body:setLinearDamping(1.5)
  end
end

function Pickup:draw()
end

function Pickup:makeActive(x,y,velx,vely)
  local vec = Vector(velx,vely)
  vec:normalize_inplace()
  local offsetx = vec.x * 100
  local offsety = vec.y * 100
  self.collider.body:setPosition(x+vec.x+offsetx,y+vec.y+offsety)
  self.collider.body:setLinearVelocity(velx,vely)
  self.collider.body:setActive(true)
  self.isActive = true
end

function Pickup:deactivate()
  self.collider.body:setActive(false)
  self.isActive = false
end

----------------------------------------------

local PickupSpawning = Pickup:addState('Spawning')
function PickupSpawning:enteredState()
  self.sprite:changeAnim('Spawning')
end

function PickupSpawning:update(dt)
  if self.spawnDropHeight > 0  then
    self.sprite:changeLoc(self.collider.body:getX(),self.collider.body:getY() - self.spawnDropHeight)
    self.spawnDropHeight = self.spawnDropHeight - dt * 50
  else
    self:gotoState('Bursting')
  end
  self.sprite:update(dt)
end

function PickupSpawning:draw()
  self.sprite:draw()
end

local PickupBursting = Pickup:addState('Bursting')
function PickupBursting:enteredState()
  self.sprite:changeAnim('Bursting')
end

function PickupBursting:update(dt)
  self.sprite:update(dt)
end

function PickupBursting:draw()
  self.sprite:draw()
end



local PickupActive = Pickup:addState('Active')
function PickupActive:enteredState()
end

function PickupActive:update(dt)
  self.sprite:update(dt)
  -- TODO: attempt at scaling the food when it is created
  if self.activeScale < self.foodScale then
    self.activeScale = self.activeScale + (dt * 1.8)
  else
    self.activeScale = self.foodScale
  end

  self.frames[self.food]:changeLoc(self.collider.body:getX(),self.collider.body:getY())
  self.frames[self.food]:changeRot(math.deg(self.collider.body:getAngle()))
  self.shadow:changeLoc(self.collider.body:getX(),self.collider.body:getY())
  self.shadow:changeRot(math.deg(self.collider.body:getAngle()))
end

function PickupActive:draw()
  if self.isActive then
    self.shadow:draw()
    self.frames[self.food]:draw(self.activeScale)
  end
end


local Falling = Pickup:addState('Falling')
function Falling:enteredState()
  self.fallt = 1

  self.collider.body:setActive(false)

end


function Falling:draw()
  if self.isActive then
    self.shadow:draw()
    self.frames[self.food]:draw(self.activeScale)
  end
end

function Falling:update(dt)
  self.sprite:update(dt)


  --timer to control the falling.
  self.fallt = self.fallt - 4 *dt


  local fall = _.smooth(100,0,self.fallt)

  print("fall",fall)

  -- TODO: attempt at scaling the food when it is created
  if self.activeScale < self.foodScale then
    self.activeScale = self.activeScale + (dt * 1.8)
  else
    self.activeScale = self.foodScale
  end

  self.frames[self.food]:changeLoc(self.collider.body:getX(),self.collider.body:getY()+fall)
  self.frames[self.food]:changeRot(math.deg(self.collider.body:getAngle()))
  --self.shadow:changeLoc(self.collider.body:getX(),self.collider.body:getY())
  --self.shadow:changeRot(math.deg(self.collider.body:getAngle()))
  if self.fallt < 0.5 then
      self:gotoState("Active")
      self:deactivate()
      Effects:makeEffect("Splash",self.collider.body:getX(),self.collider.body:getY()+fall)
  end

end

return Pickup
