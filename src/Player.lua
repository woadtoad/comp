local Pools = require("src.effectsPool")
local TexMate = require("texmate.TexMate")
local world = require('src.world')

local Player = class('Player')
Player:include(require('stateful'))

function Player:initialize()
  self.Health = 10

  --this is how we setup the animations, I may write a
  --convinence function to make generating the file names easier. so it would be a functuon that takes the name then the range of numbers to go between and return the values.
  animlist = {}
  animlist["Death"] = {
    framerate = 14,
    frames = {TexMate:frameCounter("Death",1,9,3,".png")}

  }

  animlist["Run"] = {
    framerate = 14,
    frames = {
      "fastZomb001",
      "fastZomb002",
      "fastZomb003",
      "fastZomb004",
      "fastZomb005",
      "fastZomb006",
      "fastZomb007",
      "fastZomb008",
      "fastZomb009"
    }
  }

  --make the sprite , args: atlas, animation dataformat, default animation.
  self.sprite = TexMate:new(ATLAS,animlist,"Death",nil,nil,0,-30)

  self.Pool = Pools:new(TexMate,30,ATLAS,animlist,"Death",100,100,0,-30)

  self.poolitem1 = self.Pool:makeActive()

  self.collision = world:newRectangleCollider(300, 300, 50, 50, {collision_class = 'Player'})
  self.collision.body:setFixedRotation(false)
  self.collision.fixtures['main']:setRestitution(0.3)
  self.collision.body:applyLinearImpulse(100,0,self.collision.body:getX()-30,self.collision.body:getY()-30)
end

function Player:update(dt)

  if love.keyboard.isDown("l") then
     self.Pool:deactivate(self.poolitem1.key)
  end

  self.Pool:update(dt)
  self.sprite:update(dt)

  --update the position of the sprite
  self.sprite:changeLoc(self.collision.body:getX(),self.collision.body:getY())
  self.sprite:changeRot(math.deg(self.collision.body:getAngle()))

  --update the rotation of the sprite.

end

function Player:draw()
  self.Pool:draw()
  self.sprite:draw()
end

function Player:speak()
  print("Default!")
end

function Player:keypressed(key, isrepeat)

end

--Idle state
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

local Idle = Player:addState('Idle')

function Idle:speak()
  print("Idle!")
end

function Idle:update(dt)

end

return Player
