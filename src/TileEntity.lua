local Pools = require("src.Pool")
local TexMate = require("libs.texmate.TexMate")
local WorldManager = require('src.WorldManager')
local PLAYER_STATES = require('src.Player').static.STATES
local Camera = require('src.Camera')
local Text = require('src.Text')
local TexMateStatic = require("libs.texmate.TexMateStatic")

local Tile = class('TileEntity')
Tile:include(require('libs.stateful'))

Tile.static.PLAYER_DAMAGE_INTERVAL = 0.25
Tile.static.TILE_TYPES = {
  NONE = 0,
  ICE = 1,
  STONES = 2,
  STATUES = 4,
}

function Tile:initialize (x,y,i,v,scale,typetile)
  if typetile == 0 then self.filled = false else self.filled = true end

  self.resetTime = 40
  self.type = typetile

  -- Shaker state
  self.shakermag = 0
  self.togoalshaker = 0
  self.shakertime = 0
  self.shakeDebounce = 0

  self.health = 4
  self.regenRate = 1

  local anims = {}

  anims["Spawn"] = {
    framerate = 8,
    frames = {TexMate:frameCounter("icetile2/TileRespawn_",0,10,4)}
  }

  anims["Player1Base"] = {
    framerate = 8,
    frames = {
      "goals/PinkGoal_0000"
    }
  }

  anims["Player2Base"] = {
    framerate = 8,
    frames = {
      "goals/GeenGoal_0000"
    }
  }

  anims["Player3Base"] = {
    framerate = 8,
    frames = {
      "goals/OrangeGoal_0000"
    }
  }

  anims["Player4Base"] = {
    framerate = 8,
    frames = {
      "goals/BlueGoal_0000"
    }
  }

  anims["Stone1"] = {
    framerate = 8,
    frames = {"stonetile2/TileStone_0000"}
  }

  anims["Stone2"] = {
    framerate = 8,
    frames = {"stonetile2/TileStone_0001"}
  }

  anims["Stone3"] = {
    framerate = 8,
    frames = {"stonetile2/TileStone_0002"}
  }

  anims["Statue1"] = {
    framerate = 8,
    frames = {"stonetile2/TileStatue_0000"}
  }

  anims["Statue2"] = {
    framerate = 8,
    frames = {"stonetile2/TileStatue_0001"}
  }

  anims["Statue3"] = {
    framerate = 8,
    frames = {"stonetile2/TileStatue_0002"}
  }

  anims["IdleState"] = {
    framerate = 4,
    frames = {"icetile2/TileState_0000","icetile2/TileRipple_0000","icetile2/TileRipple_0001","icetile2/TileRipple_0002"}
  }

  anims["DamageOne"] = {
    framerate = 8,
    frames = {"icetile2/TileState_0001"}
  }

  anims["DamageTwo"] = {
    framerate = 8,
    frames = {"icetile2/TileState_0002"}
  }

  anims["DamageThree"] = {
    framerate = 8,
    frames = {"icetile2/TileState_0003"}
  }

  anims["Destroy"] = {
    framerate = 8,
    frames = {"icetile2/TileBreak_0000",
              "icetile2/TileBreak_0001",
              "icetile2/TileBreak_0002",
              "icetile2/TileBreak_0003",
              "icetile2/TileBreak_0004",
              "icetile2/TileBreak_0005",
              }
  }

  anims["Blank"] = {
    framerate = 8,
    frames = {"icetile2/Blank_0000"
              }
  }

  local spriteYOffset = 10
  if self.type >= Tile.static.TILE_TYPES.STONES then
    spriteYOffset = -10
  end
  self.scale = scale
  self.sprite = TexMate(TEAMASSETS,anims,"IdleState",x,y,nil,spriteYOffset,nil,nil,self.scale)
  --(Atlas, animlist, defaultanim, x, y, pivotx, pivoty, rot, flip, scale)

  self.sprite.endCallback["Destroy"] = function()
    self.sprite:changeAnim("Blank")
  end

  self.sprite.endCallback["Spawn"] = function()
    self:gotoState("Full")
  end


  self.xcoor = v
  self.ycoor = i
  self.xoffset = 65 *self.scale
  self.yoffset = 64 *self.scale
  self.x = x
  self.y = y

  local ww = 65 * self.scale
  local hh = 70 * self.scale
  local hhh2 = 32 * self.scale
  self.collider = WorldManager.world:newPolygonCollider(
    {0, -hh, ww, -hhh2, ww, hhh2, 0, hh, -ww,hhh2,-ww,-hhh2},
    {
      body_type = 'static',
      collision_class = 'Tile',
    }
  )
  self.collider.body:setPosition(x,y)
  self.collider.parent = self

  self.players = {}
  self.damageCheckTick = 0

  if self.type == Tile.static.TILE_TYPES.ICE then
    self:gotoState("Spawn")
  end

  if self.type >= Tile.static.TILE_TYPES.STONES and self.type <= Tile.static.TILE_TYPES.STATUES then
    self:gotoState("Stone")
  end


  if self.type == Tile.static.TILE_TYPES.NONE then
    self:gotoState("Empty")
    self.collider:changeCollisionClass('Water')
  end

  if self.type >= Tile.static.TILE_TYPES.STATUES then

    self.collider:changeCollisionClass('Statue')
    self:gotoState("Statue")

  end
end

function Tile:damage(amt)
    amt = amt or 1
    self.health  = self.health - amt
end

function Tile:updateStates()
end

function Tile:regenHealth(dt)
  self.health = self.health + (self.regenRate*dt)
end

function Tile:bleedHealth(dt)
  self.health = self.health - (0.5*dt)
end

function Tile:draw()
  if self.type >= 1 then
    self.sprite:draw()
  end
end

function Tile:ddraw()
    local limit = 100
    love.graphics.setColor(0, 0, 0, 255) --Add this line
    Text.debug(self.xcoor..","..self.ycoor, self.x - limit / 2, self.y - 10, limit, 'center')
end

function Tile:update(dt)
  self:updateShake(dt)

  if self.filled == true and self.type == 1 then
    if self.collider:enter('PlayerFeet') then
      local a, pushingPlayer = self.collider:enter('PlayerFeet')
      pushingPlayer = pushingPlayer.parent

      if self.players[pushingPlayer.id] == nil then
        self:addPlayerAsDamager(pushingPlayer)
      end
    end

  --  print(self.collider:exit('PlayerFeet') )

    if self.collider:exit('PlayerFeet') then
      local a, poppingPlayer = self.collider:exit('PlayerFeet')
      poppingPlayer = poppingPlayer.parent

      if self.players[poppingPlayer.id] then
        self:removePlayerAsDamager(poppingPlayer)

      end
    end

    self:updatePlayerTicks(dt)
    self:applyPlayerDamages(dt)

    self:updateStates(dt)

  end


end

function Tile:addPlayerAsDamager(player)
  table.insert(self.players, player.id, {
    player = player,
    tick = 0
  })
  if player.instantDamage then
    if player.fat == true then
      self:damage(player.Vars.FAT_MASS_JUMP)
    else
      self:damage(player.Vars.SKINNY_MASS_JUMP)
    end
  end
end

function Tile:removePlayerAsDamager(player)
  self.players[player.id]['player'] = nil
  self.players[player.id]['tick'] = nil
  table.remove(self.players, player.id)
end

function Tile:updatePlayerTicks(dt)
  for id,conf in pairs(self.players) do
    conf.tick = conf.tick + dt
  end
end

function Tile:applyPlayerDamages(dt)
  self.damageCheckTick = self.damageCheckTick + dt
  if self.damageCheckTick > 0.1 then -- 10ms
    self.damageCheckTick = 0

    for id,conf in pairs(self.players) do
      if conf.tick > Tile.static.PLAYER_DAMAGE_INTERVAL then
        conf.tick = 0

        -- if conf.player:isMoving() then
        if conf.player.fat == false then
          self:damage(conf.player.Vars.SKINNY_MASS)
        else
          self:damage(conf.player.Vars.FAT_MASS)
        end

      end
    end
  end
end

function Tile:getLoc()
  return self.x,self.y
end

function Tile:showText(text)

end

function Tile:shaker(magnitude, time)
  self.shakermag = magnitude
  self.togoalshaker = 0
  self.shakertime = 1 / time
end

function Tile:updateShake(dt)
  local randx,randy = 0,0

  if self.togoalshaker < 1 then
    self.togoalshaker = self.togoalshaker + self.shakertime * dt
    self.shakeAmount = _.smooth( self.shakermag, -5,  self.togoalshaker)
  else
    self.shakeAmount = nil
  end

  self.shakeDebounce = self.shakeDebounce + dt
  if self.shakeDebounce > 0.045 then
    self.shakeDebounce = 0
    if self.shakeAmount then
      -- randx =  math.random(-self.shakeAmount,self.shakeAmount)
      randy =  math.random(-self.shakeAmount ,self.shakeAmount)
    end
  end

  self.sprite:changeLoc(self.x + randx, self.y + randy)
end

function Tile:addPlayerBase(id)
  self.playerId = id
  self:gotoState('PlayerBase')
end

--------------------------------------------------------

local Empty = Tile:addState('Empty')

function Empty:updateStates(dt)

  if self.collider:enter('Pickup') then
    local a, pickup = self.collider:enter('Pickup')
    pickup.parent:gotoState('Falling')
  end
end


local Stone = Tile:addState('Stone')

function Stone:enteredState(dt)
    self.sprite:changeAnim("Stone"..math.random(1,3))
end

function Stone:updateStates(dt)
  self.sprite:update(dt)
end

local PlayerBase = Tile:addState('PlayerBase')

function PlayerBase:enteredState(dt)
    self.sprite:changeAnim("Player"..self.playerId..'Base')
end

function PlayerBase:updateStates(dt)
  self.sprite:update(dt)
end
------------------------------------------------------------------------------

------------------------------------------------------------------------------

local Statue = Tile:addState('Statue')

function Statue:enteredState(dt)
    self.sprite:changeAnim("Statue"..math.random(1,3))
end

function Statue:updateStates(dt)
  self.sprite:update(dt)
end
------------------------------------------------------------------------------

------------------------------------------------------------------------------

local Spawn = Tile:addState('Spawn')

function Spawn:enteredState(dt)
    self.sprite:changeAnim("Spawn")
end

function Spawn:updateStates(dt)
  self.sprite:update(dt)
end

------------------------------------------------------------------------------

------------------------------------------------------------------------------

local Full = Tile:addState('Full')

function Full:enteredState(dt)
    self.health = 4
    self.sprite:changeAnim("IdleState")
end

function Full:updateStates(dt)
  self.sprite:update(dt)
  if self.health < 4 then
    self:gotoState("DamageOne")
  end

end

------------------------------------------------------------------------------

------------------------------------------------------------------------------

local DamageOne = Tile:addState("DamageOne")

function DamageOne:enteredState(dt)
  self:shaker(3, 0.4)
  self.sprite:changeAnim("DamageOne")
end

function DamageOne:updateStates(dt)
  self.sprite:update(dt)
  self:regenHealth(dt)

  if self.health <= 3 then
    self:gotoState("DamageTwo")
  elseif self.health >= 4 then
    self:gotoState("Full")
  end

end

------------------------------------------------------------------------------

------------------------------------------------------------------------------

local DamageTwo = Tile:addState('DamageTwo')

function DamageTwo:enteredState(dt)
  self:shaker(7, 0.4)
  self.sprite:changeAnim("DamageTwo")
end

function DamageTwo:updateStates(dt)
  self.sprite:update(dt)
  self:regenHealth(dt)
  if self.health <= 2 then
    self:gotoState("DamageThree")
  elseif self.health >= 3 then
    self:gotoState("DamageOne")
  end

end

------------------------------------------------------------------------------

------------------------------------------------------------------------------

local DamageThree = Tile:addState('DamageThree')

function DamageThree:enteredState(dt)
  self:shaker(10, 0.5)

  self.sprite:changeAnim("DamageThree")
end

function DamageThree:updateStates(dt)
  self.sprite:update(dt)
  self:bleedHealth(dt)

  if self.health <= 1 then
    self:gotoState("Destroyed")
  elseif self.health >= 2 then
    self:gotoState("DamageTwo")
  end

end

------------------------------------------------------------------------------

------------------------------------------------------------------------------

local Destroyed = Tile:addState('Destroyed')

function Destroyed:enteredState(dt)
  Camera:shaker(2,0.3)
  self.sprite:changeAnim("Destroy")
  self.resetTimer = self.resetTime
  self.collider:changeCollisionClass('Water')
end

function Destroyed:updateStates(dt)
    self.sprite:update(dt)
    self.resetTimer =  self.resetTimer - 1 * dt

    if self.resetTimer < 0 then
      self:gotoState("Spawn")
    end
end


function Destroyed:exitedState ()
  self.collider:changeCollisionClass('Tile')
end

return Tile
