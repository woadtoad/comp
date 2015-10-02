local SceneManager = require('src.SceneManager')
local SCENES = require('src.SCENES')
local hxdx = require("hxdx")
local world = require('src.world')
local Player = require('src.Player')
local Tile = require('src.TileEntity')

return function(GameScene)
  local updateList = {}

  function GameScene:initialize()
    --we are using box 2d in this example, and i am using a little library called hxcx which simplifies using box 2d a ton, but we still have access to the core mappings so it's a win win for us.
    world = hxdx.newWorld({gravity_y = 70})

    world:addCollisionClass('Ghost')
    world:collisionClassesSet()

    --level Collission
    self.ground = world:newRectangleCollider(0, 750, 1024, 50, {body_type = 'static'})
    self.lWall = world:newRectangleCollider(0, 0, 50, 800, {body_type = 'static'})
    self.rWall = world:newRectangleCollider(976, 0, 50, 800, {body_type = 'static'})

    --instantiate a new player.
    self.archer = Player:new()

    self.TileTest = Tile:new()

    --we'll just use a simple table to keep things updated
    table.insert(updateList,self.archer)
    table.insert(updateList,self.TileTest)

  end

  function GameScene:update(dt)

    if love.joystick.isDown then
      print("controller")
    end

    world:update(dt)

    --Iterate through the items for update
    for i, v in pairs(updateList) do
      updateList[i]:update(dt)
    end

  end

  function GameScene:draw()

    --Debug Drawing for physics
    world:draw()

    --Iterate through the items for update
    for i, v in pairs(updateList) do
      updateList[i]:draw()
    end

  end

  function GameScene:keypressed(key, isrepeat)

    --Test stuff
    if key == "g" then
      SceneManager:gotoState(SCENES.GAME)
    elseif key =="m" then
      SceneManager:gotoState(SCENES.MENU)
    end

    if key =="x" then
      self.archer:speak()
    end

    if key =="z" then
      self.archer:gotoState("Idle")
    end

  end

end
