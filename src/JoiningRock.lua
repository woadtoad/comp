local TexMate = require("libs.texmate.TexMate")
local SCENES = require('src.config.SCENES')
local SceneManager = require('src.SceneManager')
local Text = require('src.Text')
local PinkAnims = require('src.PinkAnims')
local GreenAnims = require('src.GreenAnims')
local OrangeAnims = require('src.OrangeAnims')
local BlueAnims = require('src.BlueAnims')

local JoiningRock = class('JoiningRock')
JoiningRock:include(require('libs.stateful'))

JoiningRock.static.WIDTH = 180 --px
JoiningRock.static.HEIGHT = 230 --px

-- TODO: move this elsewhere omg
local PLAYER_ANIMS = {
  IDLE = 'Idle',
  RUNNING = 'Running',
  SKIDDING = 'Skidding',
  JUMPING = 'Jumping',
  JUMPIDLE = 'JumpIdle',
  LANDING = 'Landing',
  FATRUN = 'FatRun',
  FATJUMP = 'FatJump',
  SPIT = 'Spit',
  EAT = 'Eat',
  STUN = 'Stun',
  FATIDLE = 'FatIdle',
  FATLAND = 'FatLand',
  RUNLAND = 'RunLand',
  SPAWNING = 'Spawning',
  FATSPAWN = 'FatSpawn',
  FALL = 'Fall',
  FATFALL = 'FatFall',
  BLANK = 'Blank',
  EAT = 'eat',
}

function JoiningRock:initialize(x, y, playerId)
  self.id = playerId
  self.x = x
  self.y = y

  local anims = {}
  anims['NotJoined'] = {
    framerate = 14,
    frames = {
      'poprocks/P'..self.id..'_0000'
    }
  }
  anims['Joining'] = {
    framerate = 12,
    frames = {
      'poprocks/P'..self.id..'_0000',
      'poprocks/P'..self.id..'_0001',
      'poprocks/P'..self.id..'_0002',
      'poprocks/P'..self.id..'_0003',
      'poprocks/P'..self.id..'_0004',
    }
  }
  anims['Leaving'] = {
    framerate = 12,
    frames = {
      'poprocks/P'..self.id..'_0004',
      'poprocks/P'..self.id..'_0003',
      'poprocks/P'..self.id..'_0002',
      'poprocks/P'..self.id..'_0001',
      'poprocks/P'..self.id..'_0000',
    }
  }
  self.rockSprite = TexMate:new(UIROCKS,  anims, "NotJoined" , nil, nil, -20, -10)

  if self.id == 1 then
    self.toadSprite = TexMate:new(PINKATLAS, PinkAnims, PLAYER_ANIMS.IDLE , nil, nil, 0, 20)
  elseif self.id == 2 then
    self.toadSprite = TexMate:new(GREENATLAS,  GreenAnims, PLAYER_ANIMS.IDLE , nil, nil, 0, 20)
  elseif self.id == 3 then
    self.toadSprite = TexMate:new(ORANGEATLAS,  OrangeAnims, PLAYER_ANIMS.IDLE , nil, nil, 0, 20)
  elseif self.id == 4 then
    self.toadSprite = TexMate:new(BLUEATLAS,  BlueAnims, PLAYER_ANIMS.IDLE , nil, nil, 0, 20)
  end

  self.rockSprite.endCallback['Joining'] = function()
    self.hasJoined = true
  end
  self.rockSprite.endCallback['Leaving'] = function()
    self.rockSprite:changeAnim('NotJoined')
  end

  self.toadSprite.endCallback[PLAYER_ANIMS.STUN] = function()
    self.toadSprite:changeAnim(PLAYER_ANIMS.IDLE)
  end
  self.toadSprite.endCallback[PLAYER_ANIMS.JUMPING] = function()
    self.toadSprite:changeAnim(PLAYER_ANIMS.IDLE)
  end
  self.toadSprite.endCallback[PLAYER_ANIMS.LANDING] = function()
    self.toadSprite:changeAnim(PLAYER_ANIMS.STUN)
  end

  self.hasJoined = false
  self.changeToadTimer = 0

  self.rockRot = 0
  self.rockRotVariation = 4
  self.rockRotLimit = self.rockRotVariation
end

function JoiningRock:update(dt)
  local ceil = 0 + self.rockRotVariation - 0.1
  local floor = 0 - self.rockRotVariation + 0.1
  if self.rockRot > ceil then
    self.rockRotLimit = 0-self.rockRotVariation
  elseif self.rockRot < floor then
    self.rockRotLimit = 0+self.rockRotVariation
  end
  self.rockRot = _.smooth(self.rockRot, self.rockRotLimit, dt*10)

  self.toadSprite:update(dt)
  self.toadSprite:changeLoc(self.x,self.y + 65)
  if not self.hasJoined then
    self.rockSprite:update(dt)
    self.rockSprite:changeLoc(self.x,self.y)
    self.rockSprite:changeLoc(self.x,self.y)
  end
  self.rockSprite:changeRot(self.rockRot)
end

function JoiningRock:draw()
  self.toadSprite:draw()
  if not self.hasJoined then
    self.rockSprite:draw()
  end

end

function JoiningRock:ddraw()
  love.graphics.setColor(255, 0, 0, 255)
  love.graphics.circle('fill', self.x, self.y, 2, 5)

  love.graphics.setColor(255, 100, 190, 255)
  love.graphics.circle('fill', self.x - JoiningRock.static.WIDTH/2, self.y - JoiningRock.static.HEIGHT/2, 2, 5)
  love.graphics.circle('fill', self.x + JoiningRock.static.WIDTH/2, self.y - JoiningRock.static.HEIGHT/2, 2, 5)
  love.graphics.circle('fill', self.x - JoiningRock.static.WIDTH/2, self.y + JoiningRock.static.HEIGHT/2, 2, 5)
  love.graphics.circle('fill', self.x + JoiningRock.static.WIDTH/2, self.y + JoiningRock.static.HEIGHT/2, 2, 5)
end

function JoiningRock:input(input)
end

function JoiningRock:join()
  print('Joining Rock')
  self.rockSprite:changeAnim('Joining')
  self.toadSprite:changeAnim(PLAYER_ANIMS.LANDING)
end

function JoiningRock:leave()
  print('Leaving Rock')
  self.hasJoined = false
  self.toadSprite:changeAnim(PLAYER_ANIMS.JUMPING)
  self.rockSprite:changeAnim('Leaving')
end

return JoiningRock
