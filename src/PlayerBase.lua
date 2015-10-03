local PlayerBase = class('PlayerBase')
local world = require('src.world')

function PlayerBase:initialize(x,y,playerId, radius)
  self.collider = world:newCircleCollider(x,y,radius,{collision_class='Base'})
  currentPoints
end

function PlayerBase:update(dt)
  if self.collider:enter('Pickup') then
    currentPoints = currentPoints + 1
  end
  if self.collider:leave('Pickup') then
    currentPoints = currentPoints - 1
  end
end
