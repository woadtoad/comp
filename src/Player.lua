local TexMate = require("texmate.TexMate")
local Vector = require('hump.vector')
local Input = require('src.Input')
local world = require('src.world')

local Player = class('Player')
Player:include(require('stateful'))

Player.static.BASE_SPEED = 30
Player.static.BASE_VEC = Vector(0, 0)
Player.static.BASE_RADIUS = 25

function Player:initialize(x, y, scale, id)
  self.Health = 10
  self.scale = scale or 1
  self.id = id or 1

  self.radius = self.scale * Player.static.BASE_RADIUS
  self.feetRadius = self.scale * (Player.static.BASE_RADIUS / 2)
  self.armRadius = self.scale * (Player.static.BASE_RADIUS / 2.5)
  self.spriteScale = self.scale / 1.4

  local playerAnims = {
    Idle = {
      framerate = 14,
      frames = {
        'mockup_toad_new/ToadIdle_0000'
      }
    },

    Running = {
      framerate = 14,
      frames = {
        'mockup_toad_new/ToadIdle_0000'
      }
    },

    Skidding = {
      framerate = 14,
      frames = {
        'mockup_toad_new/ToadIdle_0000'
      }
    }
  }

  local armAnims = {
    Idle = {
      framerate = 14,
      frames = {
        'flowerYellow.png'
      }
    }
  }

  --make the sprite , args: atlas, animation dataformat, default animation.
  self.sprite = TexMate:new(TEAMASSETS, playerAnims, "Idle" , nil, nil, 0, -10 * self.scale, nil, nil, self.spriteScale)

  self.collider = world:newCircleCollider(x, y, self.radius, {collision_class = 'PlayerBody'})
  self.collider.fixtures['main']:setRestitution(0.3)
  self.collider.body:setLinearDamping(2)
  self.collider.body:setFixedRotation(true)

  -- Add feet to player via fixed joint
  local feetXSize = self.feetRadius * 3
  local feetYSize = self.feetRadius * 2
  local feetX = x - (self.radius * 3 / 4)
  local feetY = y
  self.feet = world:newRectangleCollider(feetX, feetY, feetXSize, feetYSize, {collision_class = 'PlayerFeet'})
  self.joint = world:addJoint('RevoluteJoint', self.feet.body, self.collider.body, x, y, false)
  self.feet.body:setFixedRotation(true)
  self.feet:addShape('left', 'CircleShape', -(self.radius / 1.5), 0, self.feetRadius)
  self.feet:addShape('right', 'CircleShape', (self.radius / 1.5), 0, self.feetRadius)

  -- Add arm to Player
  self.arm = world:newCircleCollider(x, y, self.armRadius, {collision_class = 'ArmIn'})
  self.armSprite = TexMate:new(PROTOTYPEASSETS,armAnims,"Idle",nil,nil,0,0)

  self.lastXDir = 0
end

function Player:update(dt)
  self:updateMovingAnimation()

  self.sprite:update(dt)
  self.sprite:changeLoc(self.collider.body:getX(),self.collider.body:getY())

  self.armSprite:changeLoc(self.arm.body:getX(),self.arm.body:getY())
  self.sprite:changeRot(math.deg(self.arm.body:getAngle()))
end

function Player:draw()
  self.sprite:draw()
end

function Player:input(input)
  local xDir = input:down(INPUTS.MOVEX, self.id)
  local yDir = input:down(INPUTS.MOVEY, self.id)

  if xDir then
    self:moveX(xDir)
  end

  if yDir then
    self:moveY(yDir)
  end
end

  -- Grab something with an extendable fixture
function Player:grab(vec)

end

  -- Throw/spit the projectile thing
function Player:shoot(args)
end

function Player:move(dir, isY)
  local speed = Player.static.BASE_SPEED * dir * self.scale

  local x = 0
  local y = 0

  if isY then
    y = speed
  else
    x = speed
  end

  if dir > 0.3 or dir < -0.3 then
    self.sprite:changeAnim("Running", dir)
    self.collider.body:applyLinearImpulse(x, y, self.collider.body:getX(), self.collider.body:getY())
  end
end

function Player:moveX(dir)
  self:move(dir, false)
end

function Player:moveY(dir)
  self:move(dir, true)
end

function Player:updateMovingAnimation()
  local xvel, yvel = self.collider.body:getLinearVelocity()

  if xvel == 0 then
    xvel = self.lastXDir
  end

  if xvel > 10 or xvel < -10 then
    self.sprite:changeAnim("Skidding", xvel)
  else
    self.sprite:changeAnim("Idle", xvel)
  end

  self.lastXDir = xvel
end

-----------------------
-- Running State

-----------------------
-- Accl State

-----------------------
-- Throwing State

-----------------------
-- Idle State

-----------------------
-- Slide State

-----------------------
-- Stunned State

-----------------------
-- Equipped && Equipping State

-----------------------
-- Falling State

-----------------------
-- Spawning State

return Player
