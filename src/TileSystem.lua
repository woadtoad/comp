local Pools = require("src.Pool")
local world = require('src.world')
local Tile = require('src.TileEntity')
local TileMap = require("assets.gameMap5")

local TileSystem = class('TileSystem')
TileSystem:include(require('stateful'))

local viableTable = {}

function TileSystem:initialize (x, y)
  local mapWidth = TileMap.width
  local mapHeight = TileMap.height
  local newTileMap = {}
  local istile = true
  local isstone = false
  for i=1,mapWidth do
    newTileMap[i] = {}
    for v=1,mapHeight do
      table.insert(newTileMap[i], TileMap.layers[1].data[1])
      table.remove(TileMap.layers[1].data,1)
    end
  end

  self.Tiles = {}
  local scale = 0.6

  for i=1, mapWidth do
    self.Tiles[i] = {}
    for v=1, mapHeight do
      local offset = 0

        if i % 2 == 0 then offset = 65 end

        if newTileMap[i][v] >= 1 then
          istile = true
        end

        table.insert(
          self.Tiles[i],
          Tile:new(( 128*scale)*v+offset*scale,
          (
            scale*110)*i,
            i,
            v,
            scale,
            istile,newTileMap[i][v]
          )
        )

        if newTileMap[i][v] == 1 then
          table.insert(viableTable,{i,v})
          print(i,v,"is viable")
        end
      end
  end
end

function TileSystem:draw()
  --Tiles need the table drawn backwards so that overlapping looks correct
  for i=1,#self.Tiles do
    for v=1,#self.Tiles[i] do
      self.Tiles[i][v]:draw()
    end
  end

end

function TileSystem:update(dt)

  for i=1,#self.Tiles do
    for v=1,#self.Tiles[i] do
      self.Tiles[i][v]:update(dt)
    end
  end
end

--for muzza
function TileSystem:viableBuffet()
  return viableTable
end

function TileSystem:toWorld(x,y)
  return self.Tiles[x][y]:getLoc()
end

return TileSystem
