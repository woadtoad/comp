local TexMate = require("texmate.TexMate")
local Input = require('src.Input')
local world = require('src.world')

local Player = class('Player')
Player:include(require('stateful'))

function Player:initialize()
  self.Health = 10

  animlist = {}
  animlist["Idle"] = {
    framerate = 14,
    frames = {
      "alienYellow.png"
    }
  }

  --make the sprite , args: atlas, animation dataformat, default animation.
  self.sprite = TexMate:new(PROTOTYPEASSETS,animlist,"Idle",nil,nil,0,-30)

  self.collision = world:newRectangleCollider(300, 300, 50, 50, {collision_class = 'Player'})
  self.collision.body:setFixedRotation(false)
  self.collision.fixtures['main']:setRestitution(0.3)
  self.collision.body:applyLinearImpulse(100,0,self.collision.body:getX()-30,self.collision.body:getY()-30)
end

function Player:update(dt)
  self.sprite:update(dt)

  self.sprite:changeLoc(self.collision.body:getX(),self.collision.body:getY())
  self.sprite:changeRot(math.deg(self.collision.body:getAngle()))
end

function Player:draw()
  self.sprite:draw()
end

function Player:input(input)
  if input:down(INPUTS.MOVEX) then
    if input:down(INPUTS.MOVEX) > 0.3 then
      print('player moved right')
    end
    if input:down(INPUTS.MOVEX) < -0.3 then
      print('player moved left')
    end
  end

  if input:down(INPUTS.MOVEY) then
    if input:down(INPUTS.MOVEY) > 0.3 then
      print('player moved down')
    end
    if input:down(INPUTS.MOVEY) < -0.3 then
      print('player moved up')
    end
  end
end

function Player:moveUp(pressure)
end

return Player
