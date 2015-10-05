local PlayerBase = class('PlayerBase')
local WorldManager = require('src.WorldManager')
local Text = require('src.Text')

function PlayerBase:initialize(x,y,playerId,radius)
  self.theX = x
  self.theY = y
  self.theRadius = radius
  self.player = playerId
  self.collider = WorldManager.world:newCircleCollider(x,y,radius,{collision_class='Base'})
  self.currentPoints = 0
end

function PlayerBase:update(dt)
  if self.collider:enter('Pickup') then
    self.currentPoints = self.currentPoints + 1
  end
  if self.collider:exit('Pickup') then
    self.currentPoints = self.currentPoints - 1
  end
end

function PlayerBase:getcurrentPoints()
  return self.currentPoints
end

function PlayerBase:getCurrentPlayer()
  return self.player
end

function PlayerBase:draw()
end

return PlayerBase
