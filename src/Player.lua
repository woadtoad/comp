local TexMate = require("texmate.TexMate")
local Vector = require('hump.vector')
local Input = require('src.Input')
local world = require('src.world')

local Player = class('Player')
Player:include(require('stateful'))

Player.static.BASE_SPEED = 30
Player.static.BASE_VEC = Vector(0, 0)
Player.static.BASE_RADIUS = 25
Player.static.RUNNING_FPS = 12

local STATE = {
  RUN = 'run',
  SLIDE = 'slide',
  JUMP = 'jump',
}

function Player:initialize(x, y, scale, id, facing)
  print('    Player '..id)
  print('      scale: '..scale)
  print('          x: '..x)
  print('          y: '..y)
  print('')

  self.Health = 10
  self.scale = scale or 1
  self.id = id or 1
  self.isFacingRight = facing or false

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
      framerate = Player.static.RUNNING_FPS,
      frames = {
        "toad_animations/Run_0000","toad_animations/Run_0001","toad_animations/Run_0002"
      }
    },

    Skidding = {
      framerate = 14,
      frames = {
        'mockup_toad_new/ToadIdle_0000'
      }
    },

    Jumping = {
      framerate = 14,
      frames = {
        "toad_animations/Jump_0000","toad_animations/Jump_0001","toad_animations/Jump_0002","toad_animations/Jump_0003"
      }
    },
    FatRun = {
      framerate = 14,
      frames = {
        TexMate:frameCounter("toad_animations/Fat_Run_",0,16,4)
      }
    },
    FatIdle = {
      framerate = 14,
      frames = {"toad_animations/Fat_0003"

      }
    },
    FatSpawn = {
      framerate = 14,
      frames = {"toad_animations/Fat_0000","toad_animations/Fat_0001","toad_animations/Fat_0002","toad_animations/Fat_0003",

      }
    },
    eat = {
      framerate = 14,
      frames = {"toad_animations/Eat_0000","toad_animations/Eat_0001","toad_animations/Eat_0002","toad_animations/Eat_0003",

      }
    },
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
  self.sprite = TexMate:new(TEAMASSETS, playerAnims, "Idle" , nil, nil, 0, 30 * self.scale, nil, nil, self.spriteScale)

  self.collider = world:newCircleCollider(x, y, self.radius, {collision_class = 'PlayerBody'})
  self.collider.parent = self
  self.collider.fixtures['main']:setRestitution(0.3)
  self.collider.body:setLinearDamping(1.5)
  self.collider.body:setFixedRotation(true)

  self.shadowSprite = TexMate:new(TEAMASSETS, playerShadow, "Idle" , nil, nil, 0, -(self.radius), nil, nil, self.spriteScale)

  self.feetWidth = self.feetRadius * 3
  self.feetHeight = self.feetRadius * 2
  local feetX = x - (self.radius * 3 / 4)
  local feetY = y
  self.feet = world:newRectangleCollider(feetX, feetY, self.feetWidth, self.feetHeight, {collision_class = 'PlayerFeet'})
  self.feet.parent = self
  self.feetJoint = world:addJoint('RevoluteJoint', self.feet.body, self.collider.body, x, y, false)
  self.feet.body:setFixedRotation(true)
  self.feet:addShape('left', 'CircleShape', -(self.radius / 1.5), 0, self.feetRadius)
  self.feet:addShape('right', 'CircleShape', (self.radius / 1.5), 0, self.feetRadius)

  self.lastXDir = 0
  self.damagerTick = 0
  self.damagerAmount = 1
  self.effort = 1
end

function Player:update(dt)
  self:updateSprites(dt)
  self:updateStates(dt)
end

function Player:updateSprites(dt)
  self.shadowSprite:update(dt)
  self.sprite:update(dt)

  self.shadowSprite:changeLoc(self.feet.body:getX(),self.feet.body:getY())
  self.sprite:changeLoc(self.collider.body:getX(),self.collider.body:getY())
end

function Player:draw()
  self.shadowSprite:draw()
  self.sprite:draw(self.isFacingRight)
  self:drawStates(dt)
end

function Player:updateStates()
end

function Player:drawStates()
end

function Player:ddraw()
  -- Print player name
  local x, y = self.collider.body:getPosition()
  love.graphics.setColor(255, 255, 255, 100)
  love.graphics.printf('player '..self.id, x - (self.radius * self.scale), y-(50 * self.scale), self.radius * 2, 'center')

  -- Print player state
  love.graphics.setColor(220, 20, 20, 180)
  love.graphics.printf(self:getStateStackDebugInfo()[1], x - (self.radius * self.scale), y-(60 * self.scale), self.radius * 2, 'center')
end

function Player:input(input)
  local xDir = input:down(INPUTS.MOVEX, self.id)
  local yDir = input:down(INPUTS.MOVEY, self.id)

  self.isRunningForwards = false
  self.effort = 1

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

  if self.effort > 1.3 then
    self.effort = 1.3
  end
  self.sprite.animlist['Running'].framerate = Player.static.RUNNING_FPS * (self.effort)

  -- print(self.sprite.animlist['Running'].framerate)
end

function Player:isMoving()
  local vec = Vector(self.collider.body:getLinearVelocity())
  if (vec.x > 0.02 or vec.x < -0.02) or (vec.y > 0.02 or vec.y < -0.02)  then
    return true
  else
    return false
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
    local absAngle = pushingVel:angleTo(bodyVel)
    local angle = math.deg(absAngle)
    if angle < 0 then
      angle = angle * -1
    end

    local angleMod = 20
    self.isRunningForwards = angle < (90 - angleMod) or angle > (90 * 3 + angleMod)
    self.isFacingRight = xd > 0
    self.effort = angle / 360 + 1

    local x = Player.static.BASE_SPEED * xd * self.scale
    local y = Player.static.BASE_SPEED * yd * self.scale

    self.collider.body:applyLinearImpulse(x, y, self.collider.body:getX(), self.collider.body:getY())
  end
end

-----------------------
-- Running State
local RunningPlayer = Player:addState(STATE.RUN)
function RunningPlayer:enteredState()
  self.sprite:changeAnim('Running')
  self.collider.body:setLinearDamping(0.3)
end

function RunningPlayer:updateStates(dt)
end

-----------------------
-- Slide State
local SlidingPlayer = Player:addState(STATE.SLIDE)
function SlidingPlayer:enteredState()
  -- TODO: remove this when not using running anim
  self.sprite.animlist['Running'].framerate = Player.static.RUNNING_FPS
  self.sprite:changeAnim('Running')
  self.collider.body:setLinearDamping(6)
end

-----------------------
-- Jumping State
local JumpingPlayer = Player:addState(STATE.JUMP)
function JumpingPlayer:enteredState()
  self.sprite:changeAnim('Jumping')
  self.collider.body:setLinearDamping(0.2)
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
