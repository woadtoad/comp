local Pools = require("src.effectsPool")
local world = require('src.world')
local Tile = require('src.TileEntity')

local TileSystem = class('TileSystem')
TileSystem:include(require('stateful'))

function TileSystem:initialize ()
  self.Tiles = {}

  for v=1,10 do
    for i=1,10 do
      local offset = 0
        if v % 2 == 0 then offset = 40 end
        print(i,v)
        table.insert(self.Tiles,Tile:new(66*i+offset,50*v,i,v))

    end
  end

end


function TileSystem:draw()
  --Tiles need the table drawn backwards

 -- for i=#self.Tiles, 1,-1 do
  --  self.Tiles[i]:draw()
 -- end

  for i=1,#self.Tiles do
    self.Tiles[i]:draw()
  end

end

function TileSystem:update(dt)


end

return TileSystem
