local PlayerBase = class('PlayerBase')
local world = require('src.world')

local theX, theY, theRadius

function PlayerBase:initialize(x,y,playerId, radius)
  theX = x
  theY = y
  theRadius = radius
  self.collider = world:newCircleCollider(x,y,radius,{collision_class='Base'})
  --self.collider.body:setActive(false)
  currentPoints = 0
end

function PlayerBase:update(dt)
  if self.collider:enter('Pickup') then
    currentPoints = currentPoints + 1
  end
  if self.collider:exit('Pickup') then
    currentPoints = currentPoints - 1
  end
 --[[colliders = world:queryCircleArea(theX, theY, theRadius,{'Pickup'})
 for i,v in pairs(colliders) do
    print("hehe")
  end]]
end

function PlayerBase:GetCurrentPoints()
  return currentPoints
end

function PlayerBase:draw()
end

return PlayerBase