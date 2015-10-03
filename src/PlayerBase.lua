local PlayerBase = class('PlayerBase')
local world = require('src.world')

local theX,theY,theRadius,player

function PlayerBase:initialize(x,y,playerId,radius)
  self.theX = x
  self.theY = y
  self.theRadius = radius
  self.player = playerId
  self.collider = world:newCircleCollider(x,y,radius,{collision_class='Base'})
  --self.collider.body:setActive(false)
  self.currentPoints = 0
end

function PlayerBase:update(dt)
  if self.collider:enter('Pickup') then
    self.currentPoints = self.currentPoints + 1
  end
  if self.collider:exit('Pickup') then
    self.currentPoints = self.currentPoints - 1
  end
 --[[colliders = world:queryCircleArea(self.theX, self.theY, self.theRadius,{'Pickup'})
 for i,v in pairs(colliders) do
    print("hehe")
  end]]
end

function PlayerBase:getcurrentPoints()
  return self.currentPoints
end

function PlayerBase:getCurrentPlayer()
  return self.player
end

function PlayerBase:draw()
  love.graphics.setColor(255, 255, 255, 100)
  love.graphics.printf('points '..self.currentPoints, self.theX,self.theY - 10, 20, 'center')
end

return PlayerBase
