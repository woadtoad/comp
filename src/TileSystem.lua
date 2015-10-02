local Pools = require("src.Pool")
local world = require('src.world')
local Tile = require('src.TileEntity')
local TileMap = require("assets.tileset2")

local TileSystem = class('TileSystem')
TileSystem:include(require('stateful'))


function TileSystem:initialize (x,y)
  local mapWidth = TileMap.width
  local mapHeight = TileMap.height
  local newTileMap = {}
  local istile = true
  for i=1,mapWidth do
    newTileMap[i] = {}
    for v=1,mapHeight do
      table.insert(newTileMap[i], TileMap.layers[1].data[1])

      table.remove(TileMap.layers[1].data,1)

    end
  end

  self.Tiles = {}
  local scale = 0.4

  for v=1,mapWidth do
    self.Tiles[v] = {}
    for i=1,mapHeight do
      local offset = 0
        if v % 2 == 0 then offset = 65 end
          if newTileMap[i][v] == 1 then istile = true else istile = false end

          table.insert(self.Tiles[v],Tile:new((132*scale)*i+offset*scale,(scale*100)*v,i,v,scale,istile))

    end
  end
end

function TileSystem:draw()
  --Tiles need the table drawn backwards

  -- for i=#self.Tiles, 1,-1 do
  --  self.Tiles[i]:draw()
  -- end

  for i=1,#self.Tiles do
    for v=1,#self.Tiles[i] do
      self.Tiles[i][v]:draw()
    end
  end

end

function TileSystem:update(dt)


end

return TileSystem
