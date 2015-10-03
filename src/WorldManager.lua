local hxdx = require("hxdx")

local WorldManager = class('WorldManager')

local GRAVITY = 0

function WorldManager:initialize()
  self:create()
end

function WorldManager:destroy()
  self.world:destroy()
end

function WorldManager:create()
  self.world = hxdx.newWorld({
    gravity_y = GRAVITY
  })
-- Load in collision classes
  require('src.config.COLLISIONS')(self.world)
end

function WorldManager:reset()
  self:destroy()
  self:create()
end

local world = WorldManager:new()
world:initialize()
return world
