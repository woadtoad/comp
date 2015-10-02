local Pools = require("src.effectsPool")
local TexMate = require("texmate.TexMate")
local world = require('src.world')
local TexMateStatic = require("texmate.TexMateStatic")

local Tile = class('Tile')
Tile:include(require('stateful'))


function Tile:initialize (x,y,i,v)
  self.image = TexMateStatic(PROTOTYPEASSETS,"tileSnow.png",x,y,nil,30,nil,nil,0.5,nil,"center")

  self.xcoor = i
  self.ycoor = v
  self.xoffset = 65
  self.yoffset = 64
  self.x = x
  self.y = y

  self.collider = world:newPolygonCollider({10, 10, 10, 20, 20, 20, 20, 10})

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
