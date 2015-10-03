local Pools = require("src.Pool")
local TexMate = require("texmate.TexMate")
local world = require('src.world')
local TexMateStatic = require("texmate.TexMateStatic")

local Tile = class('Tile')
Tile:include(require('stateful'))

Tile.static.PLAYER_DAMAGE_INTERVAL = 0.25

function Tile:initialize (x,y,i,v,scale,active,typetile)
  self.active = active
  self.resetTime = 3
  self.type = typetile
  if active and typetile == 1 then

    self.health = 4
    self.regenRate = 1

    local anims = {}

    anims["Spawn"] = {
      framerate = 8,
      frames = {TexMate:frameCounter("icetile2/TileRespawn_",0,10,4)}
    }

    anims["Stone1"] = {
      framerate = 8,
      frames = {"stonetile2/TileStone_0000"}
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

    self.scale = scale
    self.sprite = TexMate(TEAMASSETS,anims,"IdleState",x,y,nil,10,nil,nil,self.scale)
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
    self.collider = world:newPolygonCollider(
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

    self:gotoState("Spawn")

  elseif active and typetile >= 2 then



    local anims = {}

    anims["Stone1"] = {
      framerate = 8,
      frames = {"stonetile2/TileStone_0000"}
    }

    self.scale = scale
    self.sprite = TexMate(TEAMASSETS,anims,"Stone1",x,y,nil,-20,nil,nil,self.scale)

    self.xcoor = v
    self.ycoor = i
    self.xoffset = 65 *self.scale
    self.yoffset = 64 *self.scale
    self.x = x
    self.y = y

    local ww = 65 * self.scale
    local hh = 70 * self.scale
    local hhh2 = 32 * self.scale
    self.collider = world:newPolygonCollider(
      {0, -hh, ww, -hhh2, ww, hhh2, 0, hh, -ww,hhh2,-ww,-hhh2},
      {
        body_type = 'static',
        collision_class = 'Tile',
      }
    )
    self.collider.body:setPosition(x,y)
    self.collider.parent = self

    self.players = {}

    self:gotoState("Stone")

  end

end

function Tile:damage(amt)

    self.health  = self.health - 1

end

function Tile:updateStates()
end

function Tile:regenHealth(dt)
  self.health = self.health + (self.regenRate*dt)
end

function Tile:draw()
  if self.active and self.type >= 1 then

    self.sprite:draw()

    if DEBUG.MODE == DEBUG.MODES.SHOW_GAME_AND_COLLISION or DEBUG.MODE == DEBUG.MODES.SHOW_ONLY_COLLISION then
      love.graphics.setColor(0,0,0,255) --Add this line
      love.graphics.print(self.xcoor..","..self.ycoor,self.x-20,self.y-20)
      love.graphics.setColor(255,255,255,255) --Add this line
    end
  end
end

function Tile:update(dt)
  if self.active and self.type == 1 then
    if self.collider:enter('PlayerFeet') then
      local a, pushingPlayer = self.collider:enter('PlayerFeet')
      pushingPlayer = pushingPlayer.parent

      if self.players[pushingPlayer.id] == nil then
        self:addPlayerAsDamager(pushingPlayer)
      end
    end

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
    self:damage(player.damageWeight)
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
  if self.damageCheckTick > 0.01 then -- 10ms
    self.damageCheckTick = 0

    for id,conf in pairs(self.players) do
      if conf.tick > Tile.static.PLAYER_DAMAGE_INTERVAL then
        conf.tick = 0

        -- if conf.player:isMoving() then
          self:damage(conf.player.damageWeight)
        -- end
      end
    end
  end
end

function Tile:getLoc()
  return self.x,self.y
end



local Stone = Tile:addState('Stone')

function Stone:enteredState(dt)
    self.sprite:changeAnim("Stone1")
end

function Stone:updateStates(dt)
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
  self.health = 3
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
  self.health = 2
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
  self.health = 1

  self.sprite:changeAnim("DamageThree")
end

function DamageThree:updateStates(dt)
    self.sprite:update(dt)
  self:regenHealth(dt)

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
  self.sprite:changeAnim("Destroy")
  self.resetTimer = self.resetTime
end

function Destroyed:updateStates(dt)
    self.sprite:update(dt)
    self.resetTimer =  self.resetTimer - 1 * dt

    if self.resetTimer < 0 then
      self:gotoState("Spawn")
    end
end




return Tile
