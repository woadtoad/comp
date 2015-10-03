local Pools = require("src.Pool")
local WorldManager = require('src.WorldManager')
local Tile = require('src.TileEntity')
local TileMap = require("assets.gameMap6")

local TileSystem = class('TileSystem')
TileSystem:include(require('stateful'))

function TileSystem:initialize ()
  self.mapWidth = TileMap.width
  self.mapHeight = TileMap.height
  self.spawnTable = {}
  self.newTileMap = {}
  self.viableTable = {}
  self.isTileFilled = false
  for i=1,self.mapHeight do
    local s = ((i - 1) * self.mapWidth) + 1
    local e = i * self.mapWidth
    self.newTileMap[i] = _.slice(TileMap.layers[1].data, s, e)
  end

  self.Tiles = {}
  self.scale = 0.6
  for i=1, self.mapWidth do
    self.Tiles[i] = {}
    for v=1, self.mapHeight do
      self.isTileFilled = false
      local offset = 0

        if i % 2 == 0 then offset = 65 end

        if self.newTileMap[i][v] >= 1 then
          self.isTileFilled = true
        end

        table.insert(
          self.Tiles[i],
          Tile:new(( 128*self.scale)*v+offset*self.scale,
          (
            self.scale*110)*i,
            i,
            v,
            self.scale,
            self.isTileFilled,
            self.newTileMap[i][v]
          )
        )
        if self.newTileMap[i][v] == 3 then
          table.insert(self.spawnTable,{i,v})
        end
        if self.newTileMap[i][v] == 1 then
          table.insert(self.viableTable,{i,v})

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
  local viableXandY = {}

  for i=1,#self.viableTable do
    local x,y = self.Tiles[self.viableTable[i][1]][self.viableTable[i][2]]:getLoc()
    table.insert(viableXandY,{x,y})
  end
  return viableXandY
end

function TileSystem:spawnBuffet()
  local spawnXandY = {}

  for i=1,#self.spawnTable do
    local x,y = self.Tiles[self.spawnTable[i][1]][self.spawnTable[i][2]]:getLoc()
    table.insert(spawnXandY,{x,y})
  end

  return spawnXandY
end

function TileSystem:toWorld(x,y)
  return self.Tiles[x][y]:getLoc()
end

return TileSystem
