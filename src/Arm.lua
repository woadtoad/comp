local Vector = require('hump.vector')

local Arm = class('Arm')
Arm:include(require('stateful'))

function Arm:initialize(parentBody)
  self.parent = parentBody
end

function Arm:draw()
end

function Arm:update(dt)
end

function Arm:getParentPosition()
  return self.parent:getPosition()
end

function Arm:push(angle)
  -- Change collision class of the Arm to active
  -- Apply linear force to arm self.collider
end

return Arm
