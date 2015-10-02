local SceneManager = require('src.SceneManager')
local SCENES = require('src.SCENES')
local hxdx = require("hxdx")
local world = require('src.world')
local Player = require('src.Player')
local Tile = require('src.TileEntity')
local ThePickup = require('src.Pickup')
local TileSystem = require('src.TileSystem')
local EffectSystem = require('src.EffectsPool')

return function(GameScene)
  local updateList = {}

  function GameScene:initialize()
    --we are using box 2d in this example, and i am using a little library called hxcx which simplifies using box 2d a ton, but we still have access to the core mappings so it's a win win for us.
    world:addCollisionClass('Ghost')
    world:collisionClassesSet()

    --level Collission
    self.ground = world:newRectangleCollider(0, 750, 1024, 50, {body_type = 'static'})
    self.lWall = world:newRectangleCollider(0, 0, 50, 800, {body_type = 'static'})
    self.rWall = world:newRectangleCollider(976, 0, 50, 800, {body_type = 'static'})

    --instantiate a new player.
    self.player = Player:new()

    self.TileTest = TileSystem:new()

    self.RockTest = ThePickup:new()

    self.EffectTest = EffectSystem:new()
    --we'll just use a simple table to keep things updated
    table.insert(updateList,self.player)
    table.insert(updateList,self.TileTest)
    table.insert(updateList, self.RockTest)

  end

  function GameScene:update(dt)
    world:update(dt)

    --Iterate through the items for update
    for i, v in pairs(updateList) do
      updateList[i]:update(dt)
    end

  end

  function GameScene:draw()

    if DEBUG.MODE == DEBUG.MODES.SHOW_GAME or DEBUG.MODE == DEBUG.MODES.SHOW_GAME_AND_COLLISION then
      --Iterate through the items for drawing
        self:drawFromUpdateList()
    end

    if DEBUG.MODE == DEBUG.MODES.SHOW_GAME_AND_COLLISION or DEBUG.MODE == DEBUG.MODES.SHOW_ONLY_COLLISION then
      --Debug Drawing for physics
      world:draw()
    end

  end

  function GameScene:keypressed(key, isrepeat)

    --Test stuff
    if key == "g" then
      SceneManager:gotoState(SCENES.GAME)
    elseif key =="m" then
      SceneManager:gotoState(SCENES.MENU)
    end

  end

  function GameScene:input(input)
    self.player:input(input)
  end

  function GameScene:drawFromUpdateList()
    --Iterate through the items for update
    for i, v in pairs(updateList) do
      updateList[i]:draw()
    end
  end

end
