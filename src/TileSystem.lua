local Pools = require("src.Pool")
local WorldManager = require('src.WorldManager')
local Tile = require('src.TileEntity')
local TileMap = require("assets..gameMap_Goals")

local TileSystem = class('TileSystem')
TileSystem:include(require('libs.stateful'))

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

  self.tiles = {}
  self.scale = 0.6
  for i=1, self.mapWidth do
    self.tiles[i] = {}
    for v=1, self.mapHeight do
      local offset = 0

        if i % 2 == 0 then offset = 65 end

        local newTile = Tile:new(
          ( 128*self.scale)*v+offset*self.scale,
          (self.scale*110)*i,
          i,
          v,
          self.scale,
          self.newTileMap[i][v]
        )
        table.insert(
          self.tiles[i],
          newTile
        )
        if self.newTileMap[i][v] == 3 then
          table.insert(self.spawnTable,{i,v,newTile})
        end
        if self.newTileMap[i][v] == 1 then
          table.insert(self.viableTable,{i,v})
        end


      end
  end
end

function TileSystem:draw()
  --Tiles need the table drawn backwards so that overlapping looks correct
  for i=1,#self.tiles do
    for v=1,#self.tiles[i] do
      self.tiles[i][v]:draw()
    end
  end

end

function TileSystem:ddraw()
  --Tiles need the table drawn backwards so that overlapping looks correct
  for i=1,#self.tiles do
    for v=1,#self.tiles[i] do
      self.tiles[i][v]:ddraw()
    end
  end

end

function TileSystem:update(dt)

  for i=1,#self.tiles do
    for v=1,#self.tiles[i] do
      self.tiles[i][v]:update(dt)
    end
  end
end

--for muzza
function TileSystem:viableBuffet()
  local viableXandY = {}

  for i=1,#self.viableTable do
    local x,y = self.tiles[self.viableTable[i][1]][self.viableTable[i][2]]:getLoc()
    table.insert(viableXandY,{x,y})
  end
  return viableXandY
end

function TileSystem:spawnBases()
  local spawnXandY = {}

  for i=1,#self.spawnTable do
    local x,y = self.tiles[self.spawnTable[i][1]][self.spawnTable[i][2]]:getLoc()
    table.insert(spawnXandY,{x,y})
  end

  return spawnXandY
end

function TileSystem:getBaseTiles()
  return self.spawnTable
end

function TileSystem:toWorld(x,y)
  return self.tiles[x][y]:getLoc()
end

return TileSystem
