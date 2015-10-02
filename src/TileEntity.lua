local Pools = require("src.effectsPool")
local TexMate = require("texmate.TexMate")
local world = require('src.world')
local TexMateStatic = require("texmate.TexMateStatic")

local Tile = class('Tile')
Tile:include(require('stateful'))


function Tile:initialize (x,y,i,v,scale)
  self.scale = scale
  self.image = TexMateStatic(PROTOTYPEASSETS,"tileSnow.png",x,y,nil,24,nil,nil,self.scale,nil,"center")

  self.xcoor = i
  self.ycoor = v
  self.xoffset = 65 *self.scale
  self.yoffset = 64 *self.scale
  self.x = x
  self.y = y

  local ww = 65 * self.scale
  local hh = 66 * self.scale
  local hhh2 = 34 * self.scale
  self.collider = world:newPolygonCollider({0, -hh, ww, -hhh2, ww, hhh2, 0, hh, -ww,hhh2,-ww,-hhh2},{body_type = 'static'})
  self.collider.body:setActive(false)
  self.collider.body:setPosition(x,y)
end


function Tile:draw()
  self.image:draw()

  love.graphics.setColor(0,0,0,255) --Add this line
  love.graphics.print(self.xcoor..","..self.ycoor,self.x,self.y)
  love.graphics.setColor(255,255,255,255) --Add this line

end

function Tile:update(dt)
  --self.image:update()

end

return Tile
