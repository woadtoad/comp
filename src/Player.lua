local TexMate = require("texmate.TexMate")
local Vector = require('hump.vector')
local Input = require('src.Input')
local WorldManager = require('src.WorldManager')

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
  FALL = 'fall',
  LAND = 'land'
}
Player.static.STATES = STATE

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
  self.feetRadius = self.scale * (Player.static.BASE_RADIUS / 4)
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
    JumpIdle = {
      framerate = 14,
      frames = {
        "toad_animations/Jump_0003"
      }
    },
    Landing = {
      framerate = 12,
      frames = {
        "toad_animations/Run_Land_0000","toad_animations/Run_Land_0001"
      }
    },
    FatRun = {
      framerate = 14,
      frames = {
        TexMate:frameCounter("toad_animations/Fat_Run_",0,4,4)
      }
    },
    FatJump = {
      framerate = 14,
      frames = {
        TexMate:frameCounter("toad_animations/Fat_Jump_",0,4,4)
      }
    },
    Spit = {
      framerate = 14,
      frames = {
        TexMate:frameCounter("toad_animations/Spit_",0,2,4)
      }
    },
    Eat = {
      framerate = 14,
      frames = {
        TexMate:frameCounter("toad_animations/Eat_",0,3,4)
      }
    },
    Stun = {
      framerate = 14,
      frames = {
        TexMate:frameCounter("toad_animations/Spin_",0,12,4)
      }
    },
    FatIdle = {
      framerate = 14,
      frames = {"toad_animations/Fat_0003"

      }
    },
    FatLand = {
      framerate = 14,
      frames = {TexMate:frameCounter("toad_animations/Fat_Land_",0,10,4)

      }
    },
    RunLand = {
      framerate = 14,
      frames = {TexMate:frameCounter("toad_animations/Run_Land_",0,1,4)

      }
    },
    FatSpawn = {
      framerate = 14,
      frames = {"toad_animations/Fat_0000","toad_animations/Fat_0001","toad_animations/Fat_0002","toad_animations/Fat_0003",

      }
    },
    Fall = {
      framerate = 14,
      frames = {TexMate:frameCounter("toad_animations/Fall_",0,3,4)

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
  self.sprite = TexMate:new(TEAMASSETS, playerAnims, "Idle" , nil, nil, 0, 30 + self.scale, nil, nil, self.spriteScale)

  self.sprite.endCallback['Jumping'] = function()
        self.sprite:changeAnim("JumpIdle")
  end

  self.collider = WorldManager.world:newCircleCollider(x, y, self.radius, {collision_class = 'PlayerBody'})
  self.collider.parent = self
  self.collider.fixtures['main']:setRestitution(0.3)
  self.collider.body:setLinearDamping(1.5)
  self.collider.body:setFixedRotation(true)

  self.shadowSprite = TexMate:new(TEAMASSETS, playerShadow, "Idle" , nil, nil, 0, -(self.radius), nil, nil, self.spriteScale)

  self.feetWidth = self.feetRadius * 4
  self.feetHeight = self.feetRadius * 2
  local feetX = x - self.feetWidth / 2
  local feetY = y + self.feetHeight
  self.feet = WorldManager.world:newRectangleCollider(feetX, feetY, self.feetWidth, self.feetHeight, {collision_class = 'PlayerFeet'})
  self.feet.parent = self
  self.feetJoint = WorldManager.world:addJoint('RevoluteJoint', self.feet.body, self.collider.body, x, y, false)
  self.feet.body:setFixedRotation(true)
  self.feet:addShape('left', 'CircleShape', -(self.feetWidth / 2), 0, self.feetRadius)
  self.feet:addShape('right', 'CircleShape', (self.feetWidth / 2), 0, self.feetRadius)

  self.tailWidth = self.feetRadius / 2
  self.tailHeight = self.tailWidth
  local tailX = x - self.tailWidth / 2
  local tailY = y + (self.feetRadius * 4) - self.tailWidth
  self.tail = WorldManager.world:newRectangleCollider(tailX, tailY, self.tailWidth, self.tailHeight, {collision_class = 'PlayerTail'})
  self.tail.parent = self
  self.tailJoint = WorldManager.world:addJoint('RevoluteJoint', self.tail.body, self.feet.body, x, y, false)
  self.tail.body:setFixedRotation(true)

  self.lastXDir = 0
  self.damagerTick = 0
  self.damagerAmount = 1
  self.effort = 1
  self.canControl = true
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


--debug draww
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
  if self.canControl then
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

    --print(input:pressed(INPUTS.JUMP))

    if input:pressed(INPUTS.JUMP) then
      --print("inputJump")
      self:gotoState(STATE.JUMP)
    end

    if self.effort > 1.3 then
      self.effort = 1.3
    end
    --self.sprite.animlist['Running'].framerate = Player.static.RUNNING_FPS * (self.effort)
  end
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
    self.xd,self.yd = xd,yd
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
  print("e run")
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

---------------------------

--TOOOOO FINISH JUMPING MURRY

-------------------------
local JumpingPlayer = Player:addState(STATE.JUMP)
function JumpingPlayer:enteredState()
  print("jump")
  self.canControl = false

  --this should probably be the control vector not the current velocity
  --local linear = Vector(self.collider.body:getLinearVelocity())
  linear = Vector(self.xd,self.xy)
  linear:normalize_inplace()
  local impulse = 1200
  self.sprite:changeAnim('Jumping')
  self.collider.body:setLinearDamping(0)
  self.collider.body:applyLinearImpulse(linear.x*impulse,linear.y*impulse)

  self.timerj = 0.5
end

function JumpingPlayer:updateStates(dt)
  print(self.timerj,"timer")
  self.timerj = self.timerj - 1 *dt

  if self.timerj < 0 then

    self:gotoState(STATE.LAND)
  end
end

-----------------------
-- landing State
local LandPlayer = Player:addState(STATE.LAND)
function LandPlayer:enteredState()
  print('Player landed!')
  self.collider.body:setLinearDamping(0.3)
  self.sprite:changeAnim('Landing')

  --self.canControl = false

  self.timerl = 0.2
end

function LandPlayer:updateStates(dt)
  print(self.timerj,"timer")
  self.timerl = self.timerl - 1 *dt

  if self.timerl < 0 then
    self.canControl = true
    self:gotoState(STATE.IDLE)
  end
end

-----------------------
-- Falling State
local FallingPlayer = Player:addState(STATE.FALL)
function FallingPlayer:enteredState()
  print('Player fell!')
  --self.sprite:changeAnim('Fall')
  -- self.collider.body:setLinearDamping(10)
  -- self.canControl = false
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
-- Spawning State

return Player
