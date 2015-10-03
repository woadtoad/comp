local Pools = require("src.Pool")
local TexMate = require("texmate.TexMate")
local world = require('src.world')
local TexMateStatic = require("texmate.TexMateStatic")

local Tile = class('Tile')
Tile:include(require('stateful'))


function Tile:initialize (x,y,i,v,scale,active)
  self.active = active
  if active then

    self.health = 4
    self.regenRate = 1

    local anims = {}

    anims["IdleState"] = {
      framerate = 4,
      frames = {"icetile2/TileState_0000","icetile2/TileRipple_0000"}
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

    self.scale = scale
    self.sprite = TexMate(TEAMASSETS,anims,"IdleState",x,y,nil,10,nil,nil,self.scale)
    --(Atlas, animlist, defaultanim, x, y, pivotx, pivoty, rot, flip, scale)


    self.xcoor = v
    self.ycoor = i
    self.xoffset = 65 *self.scale
    self.yoffset = 64 *self.scale
    self.x = x
    self.y = y

    local ww = 65 * self.scale
    local hh = 70 * self.scale
    local hhh2 = 32 * self.scale
    self.collider = world:newPolygonCollider({0, -hh, ww, -hhh2, ww, hhh2, 0, hh, -ww,hhh2,-ww,-hhh2},{body_type = 'static'})
    self.collider.body:setActive(false)
    self.collider.body:setPosition(x,y)
    self:gotoState("Full")
  end

end

function Tile:damage(amt)

    self.health  = self.health - 1

end

function Tile:regenHealth(dt)
  self.health = self.health + (self.regenRate*dt)
end

function Tile:draw()
  if self.active then
    self.sprite:draw()

    if DEBUG.MODE == DEBUG.MODES.SHOW_GAME_AND_COLLISION or DEBUG.MODE == DEBUG.MODES.SHOW_ONLY_COLLISION then
      love.graphics.setColor(0,0,0,255) --Add this line
      love.graphics.print(self.xcoor..","..self.ycoor,self.x-20,self.y-20)
      love.graphics.setColor(255,255,255,255) --Add this line
    end
  end
end

function Tile:update(dt)

end

function Tile:getLoc()
  return self.x,self.y
end

------------------------------------------------------------------------------

------------------------------------------------------------------------------

local Full = Tile:addState('Full')

function Full:enteredState(dt)
 -- print("full",self.health)
    self.sprite:changeAnim("IdleState")
end

function Full:update(dt)
  self.sprite:update(dt)
  if self.health < 4 then
    self:gotoState("DamageOne")
  end

end

------------------------------------------------------------------------------

------------------------------------------------------------------------------

local DamageOne = Tile:addState("DamageOne")

function DamageOne:enteredState(dt)
  print("DamageOne",self.health)
  self.sprite:changeAnim("DamageOne")
end

function DamageOne:update(dt)
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
  print("Damage2",self.health)
  self.sprite:changeAnim("DamageTwo")
end

function DamageTwo:update(dt)
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
  print("Damage3",self.health)

  self.sprite:changeAnim("DamageThree")
end

function DamageThree:update(dt)
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
  print("dest")


end

function Destroyed:update(dt)

end

function Destroyed:draw()

end


return Tile
