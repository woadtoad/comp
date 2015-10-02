local Pools = require("src.effectsPool")
local TexMate = require("texmate.TexMate")
local world = require('src.world')
local TexMateStatic = require("texmate.TexMateStatic")

local Tile = class('Tile')
Tile:include(require('stateful'))


function Tile:initialize ()
  self.image = TexMateStatic(PROTOTYPEASSETS,"tileSnow.png",100,100)


end


function Tile:draw()
  self.image:draw()

end

function Tile:update(dt)
  --self.image:update()

end

return Tile
