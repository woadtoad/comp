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
local PlayerBase = require('src.PlayerBase')

return function(GameScene)
  local updateList = {}

  function GameScene:initialize()
    love.graphics.setBackgroundColor( 100, 110, 200 )

    self.timer = 0
    self.maxTime = 60
    self.thePickupTimer = 2
    --instantiate a new player and their bases.
    self.Bases = {}
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

      -- generate a base for each player
      local base = PlayerBase:new((100*id),100,id,100)
      table.insert(self.Bases, base)
    end

    self.TileTest = TileSystem:new()

    -- create a pool of pickups
    self.pickupPool = {}

    self.EffectTest = Effects:new()


    self:resetCameraPosition()

    Camera:moveTo(love.window.getWidth() / 2+50, love.window.getHeight() / 2+350,1,1)

    --we'll just use a simple table to keep things updated

    table.insert(updateList,Camera)
    table.insert(updateList,self.TileTest)
    table.insert(updateList, self.BaseTest)
    for i, base in ipairs(self.Bases) do
      table.insert(updateList, base)
      print("player"..base:getCurrentPlayer())
    end
    for i,player in ipairs(self.players) do
      table.insert(updateList, player)
    end
  end

  function GameScene:update(dt)
    -- ************** TIMER STUFF ***************
    self.timer = self.timer + dt
    if self.timer >= self.maxTime then
      --logic here
    end
    self:updatePickupTimer(dt)
    --------- end timer stuff --------------
    world:update(dt)

    --Iterate through the items for update
    for i, v in pairs(updateList) do
      updateList[i]:update(dt)
    end

    self.EffectTest:update(dt)
  end

  function GameScene:draw()
    Camera.parent:draw(
    function(l, t, w, h)
      self:drawFromUpdateList()

      --need to put this in draw list.
      self.EffectTest:draw()

      if love.joystick.getJoystickCount() < 1 then
        love.graphics.printf('NO PLAYERS DETECTED', w / 2 - 50, 50, 100, 'center')
      end
    end
    )
  end

  function GameScene:ddraw()
    Camera.parent:draw(
    function(l, t, w, h)
      --Debug Drawing for physics
      world:draw()

      self:drawDebugPoints()

      --draw the timer
      love.graphics.setColor(255, 255, 255, 100)
      love.graphics.printf('Time: '..string.format("%.0f",self.timer), 650, 50, 50, 'center')

      for k,player in pairs(self.players) do
        player:ddraw()
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


    if key == "y" then
          Camera:shaker(100,0.5)
    end
    if key == "u" then
          Camera:shaker(10,0.2)
    end

    if key == "s" then
      print("anim")
      self.EffectTest:makeEffect("Splash",self.TileTest.Tiles[6][10]:getLoc())
    end
  end

  function GameScene:input(input)
    for i,player in ipairs(self.players) do
      player:input(input)
    end

    -- Debugging controls
    if DEBUG.MODE == DEBUG.MODES.SHOW_GAME_AND_COLLISION or DEBUG.MODE == DEBUG.MODES.SHOW_ONLY_COLLISION then
      if input:down(INPUTS.ZOOM_OUT) then
        DEBUG.ZOOM = DEBUG.ZOOM - 0.02
      end
      if input:down(INPUTS.ZOOM_IN) then
        DEBUG.ZOOM = DEBUG.ZOOM + 0.02
      end

      Camera.parent:setScale(DEBUG.ZOOM)
    end

    -- More debugging controls
    if input:pressed(INPUTS.SWITCH_MODE) then
      local MODES = 3

      DEBUG.MODE = DEBUG.MODE - 1
      if DEBUG.MODE == 0 then
        DEBUG.MODE = MODES
      end
    end
  end

  function GameScene:resetCameraPosition()
    Camera.parent:setPosition(love.window.getWidth() / 2, love.window.getHeight() / 2)
  end

  function GameScene:drawFromUpdateList()
    --Iterate through the items for update
    for i, v in pairs(updateList) do
      updateList[i]:draw()
    end
  end

  function GameScene:updatePickupTimer(dt)
    -- decrement the pickup timer
    --print(self.thePickupTimer)
    self.thePickupTimer = self.thePickupTimer - dt
    if self.thePickupTimer <=0 then
      self.viableTiles = self.TileTest:viableBuffet()
      self.theRandom = love.math.random(1,#self.viableTiles)
      self.theTile = {}
      self.theTile.x = self.viableTiles[self.theRandom][1]
      self.theTile.y = self.viableTiles[self.theRandom][2]
      print(self.theTile)
      table.insert(self.pickupPool, ThePickup:new(self.theTile.x,self.theTile.y))
      table.insert(updateList,self.pickupPool[#self.pickupPool])
      print ('DROPPIN PICKUP')
      self.thePickupTimer = love.math.random(3, 20)
    end
  end

end
