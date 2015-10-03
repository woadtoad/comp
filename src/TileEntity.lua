local Pools = require("src.Pool")
local TexMate = require("texmate.TexMate")
local world = require('src.world')
local TexMateStatic = require("texmate.TexMateStatic")

local Tile = class('Tile')
Tile:include(require('stateful'))


function Tile:initialize (x,y,i,v,scale,active)
  self.active = active
  if active then

    self.health = 3

    self.scale = scale
    self.image = TexMateStatic(TEAMASSETS,"icetile2/TileState_0000",x,y,nil,10,nil,nil,self.scale,nil,"center")

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

  end
end

function Tile:damage(amt)
  if self.active then
    local damage = amt or 1

    self.active = true

    if damage == 3 then
      self.image:changeImage("icetile2/TileState_0001")
    elseif damage == 2 then
      self.image:changeImage("icetile2/TileState_0002")
    elseif damage == 1 then
      self.image:changeImage("icetile2/TileState_0003")
    elseif damage == 0 then
      self.active = false


    end
  end
end

function Tile:draw()
  if self.active then
    self.image:draw()

    if DEBUG.MODE == DEBUG.MODES.SHOW_GAME_AND_COLLISION or DEBUG.MODE == DEBUG.MODES.SHOW_ONLY_COLLISION then
      love.graphics.setColor(0,0,0,255) --Add this line
      love.graphics.print(self.xcoor..","..self.ycoor,self.x-20,self.y-20)
      love.graphics.setColor(255,255,255,255) --Add this line
    end
  end
end

function Tile:update(dt)
  --self.image:update()

end

function Tile:getLoc()
  return self.x,self.y
end

return Tile
