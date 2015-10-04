local TexMate = require("texmate.TexMate")
local Vector = require('hump.vector')
local SCENES = require('src.config.SCENES')
local SceneManager = require('src.SceneManager')
local Input = require('src.Input')
local WorldManager = require('src.WorldManager')
local Effects = require('src.Effects')

local Player = class('Player')
Player:include(require('stateful'))

Player.static.BASE_SPEED = 30
Player.static.BASE_VEC = Vector(0, 0)
Player.static.BASE_RADIUS = 25
Player.static.RUNNING_FPS = 12

Player.transformDelay = 0



Player.Vars = {
  --control is a value from 0-1 of how much influence the player has over the movement. going above one will give more control... use with caution
  --boost is some arbitrary number given to box2d. around 1000 is a good place to start.
  --friction is a linear dampener, 1 is a lot but can go higher.
  FAT_MAX_SPEED = 0,
  SKINNY_MAX_SPEED = 0,

  FAT_STUN_AT_SPEED = 100,
  SKINNY_STUN_AT_SPEED = 280,

  SKINNY_FRICTION_RUN = 0.3,
  FAT_FRICTION_RUN = 0.3,

  SKINNY_SLIDE_RECOVER = 0,
  FAT_SLIDE_RECOVER = 0,
  FAT_SLIDE_CONTROL = 0.5,
  SKINNY_SLIDE_CONTROL = 0.5,

  FAT_POST_JUMP_FRICTION = 0,
  SKINNY_POST_JUMP_FRICTION = 0,
  FAT_POST_JUMP_CONTROL = 0.5,
  SKINNY_POST_JUMP_CONTROL = 0.5,

  FAT_JUMP_BOOST = 0,
  SKINNY_JUMP_BOOST = 0,

  FAT_SLIDE_FRICTION = 0,
  SKINNY_SLIDE_FRICTION = 0,
  FAT_SLIDE_CONTROL = 0.9,
  SKINNY_SLIDE_CONTROL = 0.9,

  EAT_BOOST = 1200,
  SPIT_BOOST = 800,

  EAT_FRICTION = 0.2,
  SPIT_FRICTION = 0.2,

  MAX_SPEED = 350,

  RESPAWN_TIME = 2

}



local STATE = {
  RUN = 'run',
  SLIDE = 'slide',
  JUMP = 'jump',
  FALL = 'fall',
  LAND = 'land',
  EAT = 'eat',
  TRANSFORM = 'transform',
  STUN = 'stun',
  SPAWNING = 'spawning',
}
Player.static.STATES = STATE

function Player:initialize(x, y, scale, id, facing)
  print('    Player '..id)
  print('      scale: '..scale)
  print('          x: '..x)
  print('          y: '..y)
  print('')

  self.spawnX = x
  self.spawnY = y

  self.Health = 10
  self.scale = scale or 1
  self.id = id or 1
  self.isFacingRight = facing or false
  self.fat = false

  --flag to not override specific states
  self.doingState = false

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
      framerate = 17,
      frames = {
        TexMate:frameCounter("toad_animations/Jump_",0,6,4)
      }
    },
    JumpIdle = {
      framerate = 14,
      frames = {
        "toad_animations/Jump_0006"
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
      framerate = 17,
      frames = {
        TexMate:frameCounter("toad_animations/Fat_Jump_",0,7,4)
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
    Spawning = {
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
      framerate = 7,
      frames = {TexMate:frameCounter("toad_animations/Fall_",0,3,4)

      }
    },
    FatFall = {
      framerate = 7,
      frames = {TexMate:frameCounter("toad_animations/Fat_Fall_",0,3,4)

      }
    },
    Blank = {
      framerate = 7,
      frames = {"icetile2/Blank_0000"

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

--[[
  local PinkAnims = require('src.PinkAnims')
  local GreenAnims = require('src.GreenAnims')
  local OrangeAnims = require('src.OrangeAnims')
  local BlueAnims = require('src.BlueAnims')
]]
  --print("does thi work,",PinkAnims['Idle'].framerate)

  local PinkAnims = require('src.PinkAnims')
  local GreenAnims = require('src.GreenAnims')
  local OrangeAnims = require('src.OrangeAnims')
  local BlueAnims = require('src.BlueAnims')

 -- self.sprite = TexMate:new(TEAMASSETS, playerAnims, "Idle" , nil, nil, 0, 30 + self.scale, nil, nil, self.spriteScale)
  if self.id == 1 then





    self.sprite = TexMate:new(PINKATLAS, PinkAnims, "Idle" , nil, nil, 0, 30 + self.scale, nil, nil, self.spriteScale)

  elseif self.id == 2 then
    self.sprite = TexMate:new(GREENATLAS,  GreenAnims, "Idle" , nil, nil, 0, 30 + self.scale, nil, nil, self.spriteScale)
  elseif self.id == 3 then
    self.sprite = TexMate:new(ORANGEATLAS,  OrangeAnims, "Idle" , nil, nil, 0, 30 + self.scale, nil, nil, self.spriteScale)
  else
    self.sprite = TexMate:new(BLUEATLAS,  BlueAnims, "Idle" , nil, nil, 0, 30 + self.scale, nil, nil, self.spriteScale)
  end


  --make the sprite , args: atlas, animation dataformat, default animation.


  self.sprite.endCallback['Jumping'] = function()
        self.sprite:changeAnim("JumpIdle")
  end

  self.sprite.endCallback['Fall'] = function()
        self.sprite:changeAnim("Blank")

        local x,y = self.collider.body:getPosition()

        Effects:makeEffect("Splash",x,y+70)

  end

  self.sprite.endCallback['FatFall'] = function()
        self.sprite:changeAnim("Blank")

        local x,y = self.collider.body:getPosition()

        Effects:makeEffect("Splash",x,y+70)

  end

  self.sprite.endCallback['Spawning'] = function()
    self.spawnSpinnerCount = self.spawnSpinnerCount - 1
    if self.spawnSpinnerCount < 1 then
      self.sprite:changeAnim("Idle")

      self:gotoState(STATE.LAND)
    end
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
  self.spawnSpinnerCount = 3

  self:gotoState(STATE.SPAWNING)
end

function Player:update(dt)
  self:updateSprites(dt)
  self:updateStates(dt)

  --STUN probably bad practice
  if self.fat == false then

      if self.collider:enter('PlayerBody') then
        local a, collider = self.collider:enter('PlayerBody')
       --print("STUNNERMATE")

        local velx,vely = collider.body:getLinearVelocity()
        local vec = Vector(velx,vely)
        local vel = vec:len()

       -- print("vel",vel)
        if vel > self.Vars.FAT_STUN_AT_SPEED and collider.parent.fat then

          self:gotoState(STATE.STUN)
        elseif vel > self.Vars.SKINNY_STUN_AT_SPEED then
          self:gotoState(STATE.STUN)
        end
      end

  end



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

  if self:getStateStackDebugInfo()[1] then
    -- Print player state
    love.graphics.setColor(220, 20, 20, 180)
    love.graphics.printf(self:getStateStackDebugInfo()[1], x - (self.radius * self.scale), y-(60 * self.scale), self.radius * 2, 'center')
  end
end

function Player:input(input)
  if input:pressed(INPUTS.PAUSE, self.id) then
    print('Player ' .. self.id .. ' paused the game')
    SceneManager:pushState(SCENES.PAUSE)
    return
  end

  if self.canControl then
    local xDir = input:down(INPUTS.MOVEX, self.id)
    local yDir = input:down(INPUTS.MOVEY, self.id)

    self.isRunningForwards = false
    self.effort = 1

    if xDir or yDir then
      self:move(xDir or 0, yDir or 0)
    end

    if self.isRunningForwards and not self.doingState then
      if self:getStateStackDebugInfo()[1] ~= STATE.RUN then
        self:gotoState(STATE.RUN)
      end
    elseif not self.doingState then
      if self:getStateStackDebugInfo()[1] ~= STATE.SLIDE then
        self:gotoState(STATE.SLIDE)
      end
    end

    --print(input:pressed(INPUTS.JUMP))

    if input:pressed(INPUTS.JUMP, self.id) then
      --print("inputJump")
      self:gotoState(STATE.JUMP)
    end

    if input:pressed(INPUTS.EAT, self.id) then
      self:gotoState(STATE.EAT)
    end

    if self.effort > 1.3 then
      self.effort = 1.3
    end

    self:stateInput(input)

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

    local x = Player.static.BASE_SPEED * xd * self.ControlInfluence
    local y = Player.static.BASE_SPEED * yd * self.ControlInfluence

    self.collider.body:applyLinearImpulse(x, y, self.collider.body:getX(), self.collider.body:getY())

    local velx2,vely2 = self.collider.body:getLinearVelocity()
    if velx2 < 0 then
      velx2 = velx2 * -1
    end
    if vely2 < 0 then
      vely2 = vely2 * -1
    end
    local vec2 = Vector(velx,vely)
    local vel2 = vec2:len()
    local maxSpeed = self.Vars.MAX_SPEED

    local x = Player.static.BASE_SPEED * xd * self.ControlInfluence
    local y = Player.static.BASE_SPEED * yd * self.ControlInfluence

    if velx2 > maxSpeed then
      --self.collider.body:setLinearVelocity()
      x = 0
    end
    if vely2 > maxSpeed then
      --self.collider.body:setLinearVelocity()
      y = 0
    end
    self.collider.body:applyLinearImpulse(x, y, self.collider.body:getX(), self.collider.body:getY())
      print("SPEEDING FINE")

  end

  print(self.collider.body:getLinearVelocity())
end

function Player:stateInput(xd, yd)

end

------------------------------------------------------------------------------------------------------------------------------------------------------------------

Player.ControlInfluence = 1



------------------------------------------------------------------------------------------------------------------------------------------------------------------

-----------------------
-- Running State
local RunningPlayer = Player:addState(STATE.RUN)
function RunningPlayer:enteredState()
  if self.fat == false then
    self.sprite:changeAnim('Running')
    self.collider.body:setLinearDamping(self.Vars.SKINNY_FRICTION_RUN)
  else
    self.sprite:changeAnim('FatRun')
    self.collider.body:setLinearDamping(self.Vars.FAT_FRICTION_RUN)
  end
end


--[[
function EaingPlayer:stateInput(input)
  local shouldGobble = false

  if  type == 'food' then
      if self.fat == false then
        self.fat = true
        self.shouldGobble = true
      end
  end

  --return shouldGobble
end]]
-----------------------
-- eating State
local EatingPlayer = Player:addState(STATE.EAT)
function EatingPlayer:enteredState()
  -- TODO: remove this when not using running anim
  self.doingState = true

    local impulse = self.Vars.EAT_BOOST




  if self.fat == false then
    self.sprite:changeAnim('Eat')
    impulse = self.Vars.EAT_BOOST
    self.collider.body:setLinearDamping(self.Vars.EAT_FRICTION)


  else
    self.sprite:changeAnim('Spit')
       impulse = self.Vars.SPIT_BOOST
      self.collider.body:setLinearDamping(self.Vars.SPIT_FRICTION)
  end

  self.timerj = 0.5

  linear = Vector(self.xd,self.yd)
    --print("pre",linear.x,linear.y)
  linear:normalize_inplace()

  --print(linear.x,linear.y)
  self.collider.body:applyLinearImpulse(linear.x*impulse,linear.y*impulse)

end

function EatingPlayer:updateStates(dt)
  self.timerj = self.timerj - 1 *dt
  self.transformDelay = self.transformDelay - 1 *dt


  if self.timerj < 0 then
    self.doingState = false
    self:gotoState(STATE.IDLE)
  end

  if self.fat == false and self.transformDelay < 0  then
    if self.pickedUpFood == nil then
      if self.collider:enter('Pickup') then

        local a, collider = self.collider:enter('Pickup')
       -- pushingPlayer = pushingPlayer.parent
        self.fat = true
        self.transformDelay = 0.1

        collider.parent:deactivate()
        self.pickedUpFood = collider.parent

        self:gotoState(STATE.TRANSFORM)
      end
   end
  elseif self.fat == true and self.transformDelay < 0 then
      self.fat = false
      self.transformDelay = 0.1
      local x,y = self.collider.body:getPosition()
      local velx,vely = self.collider.body:getLinearVelocity()
      self.pickedUpFood:makeActive(x,y,velx,vely)
      self.pickedUpFood = nil
  end

end
-----------------------
-- Slide State
local SlidingPlayer = Player:addState(STATE.SLIDE)
function SlidingPlayer:enteredState()
  -- TODO: remove this when not using running anim
 -- self.sprite.animlist['Running'].framerate = Player.static.RUNNING_FPS
  if self.fat == false then
    self.sprite:changeAnim('Running')
  else
    self.sprite:changeAnim('FatRun')
  end

  self.collider.body:setLinearDamping(6)
end

-- Transform State
local Transform = Player:addState(STATE.TRANSFORM)
function Transform:enteredState()
  -- TODO: remove this when not using running anim
 -- self.sprite.animlist['Running'].framerate = Player.static.RUNNING_FPS
  self.canControl = false
  self.sprite:changeAnim('FatSpawn')

  self.collider.body:setLinearDamping(10)

  self.timerj = 0.4
end


function Transform:updateStates(dt)

  self.timerj = self.timerj - 1 *dt

  if self.timerj < 0 then
    self.canControl = true
    self:gotoState(STATE.RUN)
  end
end


-----------------------
-- Jumping State

---------------------------

local JumpingPlayer = Player:addState(STATE.JUMP)
function JumpingPlayer:enteredState()
  self.canControl = false

  --this should probably be the control vector not the current velocity
  --local linear = Vector(self.collider.body:getLinearVelocity())

  local impulse = 1200

  if self.fat == false then
    self.sprite:changeAnim('Jumping')
    self.timerj = 0.4
  else
    self.sprite:changeAnim('FatJump')
    self.timerj = 0.45
  end

  self.collider.body:setLinearDamping(0)
  linear = Vector(self.xd,self.yd)
  linear:normalize_inplace()
  self.collider.body:applyLinearImpulse(linear.x*impulse,linear.y*impulse)


end

function JumpingPlayer:updateStates(dt)
  self.timerj = self.timerj - 1 *dt

  if self.timerj < 0 then

    self:gotoState(STATE.LAND)
  end
end

-----------------------
-- landing State
local StunState = Player:addState(STATE.STUN)
function StunState:enteredState()
  self.collider.body:setLinearDamping(0.3)
  if self.fat == false then
    self.sprite:changeAnim('Stun')
    self.timerl = 0.86
    self.canControl = false
  else
   -- self.sprite:changeAnim('FatLand')
   -- self.timerl = 0.4
   --DO SPIT
  end
end

function StunState:updateStates(dt)
  --print(self.timerj,"timer")
  self.timerl = self.timerl - 1 *dt

  if self.timerl < 0 then
    self.canControl = true
    self:gotoState(STATE.RUN)
  end
end

-----------------------
-- landing State
local LandPlayer = Player:addState(STATE.LAND)
function LandPlayer:enteredState()
  self.collider.body:setLinearDamping(0.3)
  if self.fat == false then
    self.sprite:changeAnim('Landing')
    self.timerl = 0.2
  else
    self.sprite:changeAnim('FatLand')
    self.timerl = 0.4
  end
  --self.canControl = false
end

function LandPlayer:updateStates(dt)
  --print(self.timerj,"timer")
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
  if self.fat == false then
    self.sprite:changeAnim('Fall')
  else
    self.sprite:changeAnim('FatFall')
  end

  self.collider.body:setLinearDamping(10)
  self.canControl = false
  self.hasFallen = true
  self.respawnTimer = self.Vars.RESPAWN_TIME -- ms
end

function FallingPlayer:updateStates(dt)
  if self.hasFallen then
    self.respawnTimer = self.respawnTimer - dt
    if self.respawnTimer < 0 then
      print('Respawning player')
      self.hasFallen = false
      self.collider.body:setPosition(self.spawnX + self.radius, self.spawnY)
      self:gotoState(STATE.SPAWNING)
    end
  end
end


-----------------------
-- Spawning State
local SpawningPlayer = Player:addState(STATE.SPAWNING)
function SpawningPlayer:enteredState()
  self.sprite:changeAnim('Spawning')
  self.canControl = false
end

-----------------------
-- Throwing State

-----------------------
-- Idle State

-----------------------
-- Stunned State

-----------------------
-- Equipped && Equipping State

return Player
