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
    Sounds.loop({SOUNDS.INTRO})
    self.joiningPlayers = {}
    self.rocks = {}

    local rockW = JoiningRock.static.WIDTH
    local rockH = JoiningRock.static.HEIGHT
    local rockPadding = 20
    local rockStartX = (love.graphics.getWidth() / 2) - (rockW * 2) - (rockPadding + rockPadding / 2)
    local rockY = love.window.getHeight() / 2 + rockH / 2 + 80

    for id=1, MAX_PLAYERS do
      self.joiningPlayers[id] = false
      local padding = (id - 1) * rockPadding
      local offset = id * rockW
      local rockX = rockStartX + padding + (rockW * (id - 1) + rockW/2)

      self.rocks[id] = JoiningRock:new(rockX, rockY, id)
    end
  end

  function StartScene:update(dt)
    for k,rock in pairs(self.rocks) do
      rock:update(dt)
    end
  end

  function StartScene:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local limit = 300
    local yStart = 100

    love.graphics.setColor(20, 120, 20, 120)
    love.graphics.rectangle('fill', 0, 0, w, h)

    love.graphics.setColor(255, 255, 255, 255)
    Text.huge('START SCREEN', w / 2 - (limit / 2), yStart, limit, 'center')
    Text.huge('START to join', w / 2 - (limit / 2), yStart + 200, limit, 'center')
    Text.huge('A to start', w / 2 - (limit / 2), yStart + 250, limit, 'center')

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
        self.joiningPlayers[id] = not self.joiningPlayers[id]
        if self.joiningPlayers[id] then
          print('Player ' .. joystick:getID() .. ' joined')
          self.rocks[id]:join()
        else
          print('Player ' .. joystick:getID() .. ' left')
          self.rocks[id]:leave()
        end
      end
    end

    -- Player 1 starts the game
    -- Start the game!
    if input:pressed(INPUTS.START_GAME) then
      self:pushState(SCENES.GAME)
    end
  end

  function StartScene:destroy()
  end

end
