local SceneManager = require('src.SceneManager')
local SCENES       = require('src.config.SCENES')
local hxdx         = require("hxdx")
local WorldManager = require('src.WorldManager')
local Camera       = require('src.Camera')
local Sounds       = require('src.Sound')
local Player       = require('src.Player')
local Tile         = require('src.TileEntity')
local ThePickup    = require('src.Pickup')
local TileSystem   = require('src.TileSystem')
local Effects      = require('src.Effects')
local PlayerBase   = require('src.PlayerBase')

local CAMERA_SCALE = 0.8

return function(GameScene)

  function GameScene:initialize()
    print('  GameScene:initialize')
    if self.initialized then
      return
    end

    Camera:setScale(CAMERA_SCALE)
    love.graphics.setBackgroundColor( 100, 110, 200 )
    self.initialized = true
  end

  function GameScene:enteredState()
    print('  GameScene:enteredState')
    self:initialize()
    self:reset()
  end

  function GameScene:exitedState()
    print('  GameScene:exitedState')
    self:destroy()
    -- self:reset()
  end

  function GameScene:pausedState()
    print('  GameScene:pausedState')
    self:pause()
  end

  function GameScene:continuedState()
    print('  GameScene:continuedState')
    self:destroy()
    self:reset()
  end

  function GameScene:pause()
    self.paused = true
  end

  function GameScene:reset()
    Sounds.loop({SOUNDS.BATTLE})

    Camera:setScale(CAMERA_SCALE)
    -- DIRTY reset for the game.
    -- TODO: make sure GC cleans up all the games objects
    self.updateList = {}
    self.drawList = {}

    self.spawnTimes = {5,5,5,6,7,9,10,15,20,26,30}
    self.spawnTimesPos = 1

    self.paused = false
    self.timer = 0
    self.maxTime = 60
    self.thePickupTimer = 2

    --instantiate a new player and their bases.
    self.bases = {}
    self.players = {}

    self.tileSystem = TileSystem:new()
    self.spawnTiles = self.tileSystem:spawnBases()
    --instantiate a new player and their bases.
    for i,joystick in pairs(love.joystick.getJoysticks()) do
      local id = joystick:getID()
      local player = Player:new(
        self.spawnTiles[id][1],
        self.spawnTiles[id][2],
        1,
        id
      )

      table.insert(self.players, player)

      -- generate a base for each player
      local base = PlayerBase:new(
          self.spawnTiles[id][1],
          self.spawnTiles[id][2],
          id,
          100
      )
      self.tileSystem:getBaseTiles()[id][3]:addPlayerBase(id)
      table.insert(self.bases, base)
    end

    -- create a pool of pickups
    self.pickupPool = {}

    self.Effects = Effects

    self:resetCameraPosition()
    Camera:setScale(CAMERA_SCALE)
    Camera:moveTo(love.window.getWidth() / 2+120, love.window.getHeight() / 2 + 140,1,1)

    -- UPDATE list
    table.insert(self.updateList,Camera)
    table.insert(self.updateList,self.tileSystem)
    for i, base in ipairs(self.bases) do
      table.insert(self.updateList, base)
    end
    for i,player in ipairs(self.players) do
      table.insert(self.updateList, player)
    end

    -- DRAW list
    table.insert(self.drawList,Camera)
    table.insert(self.drawList,self.tileSystem)
    for i, base in ipairs(self.bases) do
      table.insert(self.drawList, base)
    end
    for i,player in ipairs(self.players) do
      table.insert(self.drawList, player)
    end
  end

  function GameScene:update(dt)
    if not self.paused then
      -- ************** TIMER STUFF ***************
      self.timer = self.timer + dt
      if self.timer >= self.maxTime then
        self:pushState(SCENES.END)
      end
      self:updatePickupTimer(dt)
      --------- end timer stuff --------------
      WorldManager.world:update(dt)

      --Iterate through the items for update
      for i, v in pairs(self.updateList) do
        self.updateList[i]:update(dt)
      end

      self.Effects:update(dt)
    end
  end

  function GameScene:draw()
    Camera.parent:draw(
    function(l, t, w, h)
      for i, v in pairs(self.drawList) do
        self.drawList[i]:draw()
      end
      --need to put this in draw list.
      self.Effects:draw()
    end
    )

    local l = 0
    local t = 0
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    local limit = 200

    -- Draw ui box
    love.graphics.setColor(20, 20, 20, 150)
    love.graphics.rectangle('fill', w / 2 - limit / 2, 50 / 2 + 10, limit, 40)

    if love.joystick.getJoystickCount() < 1 then
      love.graphics.printf('NO PLAYERS DETECTED', w / 2 - limit / 2, 50, limit, 'center')
    else
      --draw the timer
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.printf('Time: '..string.format("%.0f",self.maxTime - self.timer), w / 2 - limit / 2, 50, limit, 'center')
    end
  end

  function GameScene:ddraw()
    Camera.parent:draw(
    function(l, t, w, h)
      --Debug Drawing for physics
      WorldManager.world:draw()

      self:drawDebugPoints()

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
    if key == "q" then
      SceneManager:gotoState(SCENES.START)
    elseif key =="w" then
      self:pushState(SCENES.PAUSE)
    elseif key =="e" then
      SceneManager:gotoState(SCENES.GAME)
    elseif key =="r" then
      self:pushState(SCENES.END)
    end

    if key == "y" then
          Camera:shaker(100,0.5)
    end
    if key == "u" then
          Camera:shaker(10,0.2)
    end

    if key == "s" then
      self.Effects:makeEffect("Splash",self.tileSystem.Tiles[6][10]:getLoc())
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

      -- Camera.parent:setScale(DEBUG.ZOOM)
    end

    -- More debugging controls
    if input:pressed(INPUTS.SWITCH_MODE) then
      local MODES = 3

      DEBUG.MODE = DEBUG.MODE - 1
      if DEBUG.MODE == 0 then
        DEBUG.MODE = MODES
      end
    end

    -- Reload the game scene!
    if input:pressed(INPUTS.RELOAD) then
      DEBUG.MODE = DEBUG.MODES.SHOW_GAME
      DEBUG.ZOOM = 1

      self:gotoState(SCENES.GAME)
    end
  end

  function GameScene:resetCameraPosition()
    Camera.parent:setPosition(love.window.getWidth() / 2, love.window.getHeight() / 2)
  end

  function GameScene:updatePickupTimer(dt)
    -- decrement the pickup timer
    self.thePickupTimer = self.thePickupTimer - dt
    if self.thePickupTimer <=0 then
      self.viableTiles = self.tileSystem:viableBuffet()
      self.theRandom = love.math.random(1,#self.viableTiles)
      self.theTile = {}
      self.theTile.x = self.viableTiles[self.theRandom][1]
      self.theTile.y = self.viableTiles[self.theRandom][2]
      table.insert(self.pickupPool, ThePickup:new(self.theTile.x,self.theTile.y))
      table.insert(self.updateList,self.pickupPool[#self.pickupPool])
      table.insert(self.drawList,self.pickupPool[#self.pickupPool])
      --[[ random timing
      self.thePickupTimer = love.math.random(3, 20)]]
      -- table timing
      if self.spawnTimesPos <= #self.spawnTimes then
        self.thePickupTimer = self.spawnTimes[self.spawnTimesPos]
      else
        self.thePickupTimer = self.spawnTimes[#self.spawnTimes]
      end
    end
  end

  function GameScene:destroy()
    WorldManager:reset()
  end

end
