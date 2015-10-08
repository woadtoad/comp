local SceneManager = require('src.SceneManager')
local SCENES = require('src.config.SCENES')
local Camera = require('src.Camera')
local Player = require('src.Player')
local Sounds = require('src.Sound')
local Text = require('src.Text')
local JoiningRock = require('src.JoiningRock')
local PlayerBase = require('src.PlayerBase')

local MAX_PLAYERS = 4

return function(StartScene)

  function StartScene:initialize()
    print('  StartScene:initialize')
    if self.initialized then
      return
    end

    love.graphics.setBackgroundColor( 100, 110, 200 )
    self.initialized = true
  end

  function StartScene:enteredState()
    print('  StartScene:enteredState')
    self:initialize()
    self:reset()
  end

  function StartScene:exitedState()
    print('  StartScene:exitedState')
    self:destroy()
  end

  function StartScene:pausedState()
    print('  StartScene:pausedState')
  end

  function StartScene:continuedState()
    print('  StartScene:continuedState')
    self:destroy()
    self:reset()
  end

  function StartScene:reset()
    Sounds.stop()
    Sounds.play(SOUNDS.INTRO, {}, 1, 1, function()
      if self:current() == SCENES.START then
        Sounds.loop({SOUNDS.MENU_DRUMS})
      end
    end)
    self.joinedPlayers = {}
    self.rocks = {}

    local rockW = JoiningRock.static.WIDTH
    local rockH = JoiningRock.static.HEIGHT
    local rockPadding = 80
    local rockStartX = (love.graphics.getWidth() / 2) - (rockW * 2) - (rockPadding + rockPadding / 2)
    local rockY = love.window.getHeight() / 2 + rockH / 2 + 80

    for id=1, MAX_PLAYERS do
      self.joinedPlayers[id] = false

      -- Setup the position for the joining rocks
      local padding = (id - 1) * rockPadding
      local offset = id * rockW
      local rockX = rockStartX + padding + (rockW * (id - 1) + rockW/2)
      self.rocks[id] = JoiningRock:new(rockX, rockY, id)
    end
    self.textScale = 1
    self.textScaleLimit = 1.3
  end

  function StartScene:update(dt)
    local vari = 0.07
    local ceil = 1 + vari - 0.02
    local floor = 1 - vari + 0.02
    if self.textScale > ceil then
      self.textScaleLimit = 1-vari
    elseif self.textScale < floor then
      self.textScaleLimit = 1+vari
    end

    self.textScale = _.smooth(self.textScale, self.textScaleLimit, dt*9)

    local activeControllers = {
      [1] = false,
      [2] = false,
      [3] = false,
      [4] = false,
    }
    for k,joystick in pairs(love.joystick.getJoysticks()) do
      local id = joystick:getID()
      activeControllers[id] = true
      self.rocks[id]:activate()
    end
    for id,isActive in pairs(activeControllers) do
      if isActive then
        self.rocks[id]:activate()
      else
        self.rocks[id]:deactivate()
      end
    end

    for k,rock in pairs(self.rocks) do
      rock:update(dt)
    end
  end

  function StartScene:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local limit = 800
    local yStart = 100

    love.graphics.setColor(144, 126, 114, 255)
    love.graphics.rectangle('fill', 0, 0, w, h)

    love.graphics.setColor(69, 64, 74, 255)
    Text.massive('WOAD TOADS', w / 2 - (limit / 2), yStart, limit, 'center')

    if _.any(self.joinedPlayers) then
      Text.huge('A to start', w / 2 - (limit / 2) * self.textScale, yStart + 250, limit, 'center', 0, self.textScale)
    end

    for k,rock in pairs(self.rocks) do
      rock:draw()
    end
  end

  function StartScene:ddraw()
    for k,rock in pairs(self.rocks) do
      rock:ddraw()
    end
    love.graphics.setColor(0, 0, 255, 255)
    love.graphics.circle('fill', love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 5, 10)
  end

  function StartScene:keypressed(key, isrepeat)
    --Start the game, lel
    if key == " " then
      self:pushState(SCENES.GAME)
    end
  end

  function StartScene:input(input)
    for k,joystick in pairs(love.joystick.getJoysticks()) do
      local id = joystick:getID()
      -- Join the game!
      if input:pressed(INPUTS.JOIN_GAME, id) then
        self.joinedPlayers[id] = not self.joinedPlayers[id]
        if self.joinedPlayers[id] then
          print('Player ' .. joystick:getID() .. ' joined')
          Sounds.play(SOUNDS.MENU_SELECT)
          self.rocks[id]:join()
        else
          print('Player ' .. joystick:getID() .. ' left')
          Sounds.play(SOUNDS.MENU_UNSELECT)
          self.rocks[id]:leave()
        end
      end
    end

    -- Player 1 starts the game
    -- Start the game!
    if input:pressed(INPUTS.START_GAME) then
      if _.any(self.joinedPlayers) then
        self:pushState(SCENES.GAME)
      end
    end
  end

  function StartScene:destroy()
  end

end
