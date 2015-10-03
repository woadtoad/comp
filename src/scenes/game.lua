local SceneManager = require('src.SceneManager')
local SCENES = require('src.config.SCENES')
local hxdx = require("hxdx")
local world = require('src.world')
local Camera = require('src.Camera')
local Player = require('src.Player')
local Tile = require('src.TileEntity')
local ThePickup = require('src.Pickup')
local TileSystem = require('src.TileSystem')
local Effects = require('src.Effects')

return function(GameScene)
  local updateList = {}

  function GameScene:initialize()
    --we are using box 2d in this example, and i am using a little library called hxcx which simplifies using box 2d a ton, but we still have access to the core mappings so it's a win win for us.
    world:addCollisionClass('Ghost')
    world:collisionClassesSet()


    love.graphics.setBackgroundColor( 100, 110, 200 )

    --instantiate a new player.
    self.players = {}
    for i,joystick in ipairs(love.joystick.getJoysticks()) do
      local id = joystick:getID()
      local player = Player:new(
      love.graphics.getWidth() / 2,
      love.graphics.getHeight() / 2,
      1,
      id
      )

      table.insert(self.players, player)
    end

    self.TileTest = TileSystem:new()

    self.RockTest = ThePickup:new()

    self.EffectTest = Effects:new()

    self.EffectTest:makeEffect("Explosion",0,-120,self.TileTest.Tiles[10][10]:getLoc())

    self:resetCameraPosition()
    --we'll just use a simple table to keep things updated

    table.insert(updateList,self.TileTest)
    table.insert(updateList, self.RockTest)
    for i,player in ipairs(self.players) do
      table.insert(updateList, player)
    end
  end

  function GameScene:update(dt)
    world:update(dt)

    --Iterate through the items for update
    for i, v in pairs(updateList) do
      updateList[i]:update(dt)
    end

    self.EffectTest:update(dt)
  end

  function GameScene:draw()
    Camera:draw(
    function(l, t, w, h)
      if DEBUG.MODE == DEBUG.MODES.SHOW_GAME or DEBUG.MODE == DEBUG.MODES.SHOW_GAME_AND_COLLISION then
        --Iterate through the items for drawing
          self:drawFromUpdateList()
      end

      if DEBUG.MODE == DEBUG.MODES.SHOW_GAME_AND_COLLISION or DEBUG.MODE == DEBUG.MODES.SHOW_ONLY_COLLISION then
        self:drawDebugPoints()

        --Debug Drawing for physics
        world:draw()
      end
      --need to put this in draw list.
      self.EffectTest:draw()


      if love.joystick.getJoystickCount() < 1 then
        love.graphics.printf('NO PLAYERS DETECTED', w / 2 - 50, 50, 100, 'center')
      end
    end
    )
  end

  function GameScene:drawDebugPoints()
      local radius = 5
      local segments = 10

      -- RED == CORNERS
      love.graphics.setColor(255, 80, 80)
      love.graphics.circle('fill', 0, 0, radius, segments)
      love.graphics.circle('fill', love.window.getWidth(), 0, radius, segments)
      love.graphics.circle('fill', 0, love.window.getHeight(), radius, segments)
      love.graphics.circle('fill', love.window.getWidth(), love.window.getHeight(), radius, segments)

      -- BLUE == CENTER
      love.graphics.setColor(80, 80, 255);
      love.graphics.circle('fill', love.window.getWidth() / 2, love.window.getHeight() / 2, radius, segments)
  end

  function GameScene:keypressed(key, isrepeat)

    --Test stuff
    if key == "g" then
      SceneManager:gotoState(SCENES.GAME)
    elseif key =="m" then
      SceneManager:gotoState(SCENES.MENU)
    end

    if key == " " then
        self.TileTest.Tiles[10][10]:damage()
    end

  end

  function GameScene:input(input)
    for i,player in ipairs(self.players) do
      player:input(input)
    end
  end

  function GameScene:resetCameraPosition()
    Camera:setPosition(love.window.getWidth() / 2, love.window.getHeight() / 2)
  end

  function GameScene:drawFromUpdateList()
    --Iterate through the items for update
    for i, v in pairs(updateList) do
      updateList[i]:draw()
    end
  end

end
