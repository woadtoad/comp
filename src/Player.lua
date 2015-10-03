local TexMate = require("texmate.TexMate")
local Vector = require('hump.vector')
local Input = require('src.Input')
local world = require('src.world')

local Player = class('Player')
Player:include(require('stateful'))

Player.static.BASE_SPEED = 30
Player.static.BASE_VEC = Vector(0, 0)
Player.static.BASE_RADIUS = 25

local STATE = {
  RUN = 'run',
  SLIDE = 'slide',
}

function Player:initialize(x, y, scale, id)
  print('    Player '..id)
  print('      scale: '..scale)
  print('          x: '..x)
  print('          y: '..y)
  print('')

  self.Health = 10
  self.scale = scale or 1
  self.id = id or 1

  self.radius = self.scale * Player.static.BASE_RADIUS
  self.feetRadius = self.scale * (Player.static.BASE_RADIUS / 2)
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

  local playerShadow = {
    Idle = {
      framerate = 1,
      frames = {
        'mockup_toad_new/Shadow_0000'
      }
    }
  }

  --make the sprite , args: atlas, animation dataformat, default animation.
  self.sprite = TexMate:new(TEAMASSETS, playerAnims, "Idle" , nil, nil, 0, -10 * self.scale, nil, nil, self.spriteScale)

  self.collider = world:newCircleCollider(x, y, self.radius, {collision_class = 'PlayerBody'})
  self.collider.fixtures['main']:setRestitution(0.3)
  self.collider.body:setLinearDamping(1.5)
  self.collider.body:setFixedRotation(true)

  self.shadowSprite = TexMate:new(TEAMASSETS, playerShadow, "Idle" , nil, nil, 0, -(self.radius), nil, nil, self.spriteScale)

  self.feetWidth = self.feetRadius * 3
  self.feetHeight = self.feetRadius * 2
  local feetX = x - (self.radius * 3 / 4)
  local feetY = y
  self.feet = world:newRectangleCollider(feetX, feetY, self.feetWidth, self.feetHeight, {collision_class = 'PlayerFeet'})
  self.feetJoint = world:addJoint('RevoluteJoint', self.feet.body, self.collider.body, x, y, false)
  self.feet.body:setFixedRotation(true)
  self.feet:addShape('left', 'CircleShape', -(self.radius / 1.5), 0, self.feetRadius)
  self.feet:addShape('right', 'CircleShape', (self.radius / 1.5), 0, self.feetRadius)

  self.lastXDir = 0
  self.damagerTick = 0
  self.damagerAmount = 1
end

function Player:update(dt)
  self:updateMovingAnimation()

  self:updateSprites(dt)
end

function Player:updateSprites(dt)
  self.shadowSprite:update(dt)
  self.sprite:update(dt)

  self.shadowSprite:changeLoc(self.feet.body:getX(),self.feet.body:getY())
  self.sprite:changeLoc(self.collider.body:getX(),self.collider.body:getY())
end

function Player:draw()
  self.shadowSprite:draw()
  self.sprite:draw()
end

function Player:ddraw()
  -- Print player name
  local x, y = self.collider.body:getPosition()
  love.graphics.setColor(255, 255, 255, 100)
  love.graphics.printf('player '..self.id, x - (self.radius / 2 * self.scale), y-(50 * self.scale), 20, 'center')

  -- Print player state
  love.graphics.setColor(220, 20, 20, 180)
  love.graphics.printf(self:getStateStackDebugInfo()[1], x - (self.radius / 2 * self.scale), y-(60 * self.scale), 20, 'center')
end

function Player:input(input)
  local xDir = input:down(INPUTS.MOVEX, self.id)
  local yDir = input:down(INPUTS.MOVEY, self.id)

  self.isRunningForwards = false

  if xDir or yDir then
    self:move(xDir or 0, yDir or 0)
  end

  if self.isRunningForwards then
    if self:getStateStackDebugInfo()[1] ~= STATE.RUN then
      self:gotoState(STATE.RUN)
    end
  else
    if self:getStateStackDebugInfo()[1] ~= STATE.SLIDE then
      self:gotoState(STATE.SLIDE)
    end
  end
end

function Player:move(xd, yd)
  if (xd > 0.3 or xd < -0.3) or(yd > 0.3 or yd < -0.3)  then
    -- Establish the fact our player is making the Player
    -- run forwards
    local bodyVel = Vector(self.collider.body:getLinearVelocity())
    bodyVel = bodyVel:normalized()
    local pushingVel = Vector(xd, yd)
    pushingVel = pushingVel:normalized()
    local angle = math.deg(pushingVel:angleTo(bodyVel))
    if angle < 0 then
      angle = angle * -1
    end

    local angleMod = 20
    self.isRunningForwards = angle < (90 - angleMod) or angle > (90 * 3 + angleMod)
    -- print("self.isRunningForwards->", self.isRunningForwards)

    local x = Player.static.BASE_SPEED * xd * self.scale
    local y = Player.static.BASE_SPEED * yd * self.scale

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
local RunningPlayer = Player:addState(STATE.RUN)
function RunningPlayer:enteredState()
  self.collider.body:setLinearDamping(0.3)
end

-----------------------
-- Slide State
local SlidingPlayer = Player:addState(STATE.SLIDE)
function SlidingPlayer:enteredState()
  self.collider.body:setLinearDamping(6)
end

-----------------------
-- Throwing State

-----------------------
-- Idle State

-----------------------
-- Stunned State

-----------------------
-- Equipped && Equipping State

-----------------------
-- Falling State

-----------------------
-- Spawning State

return Player
