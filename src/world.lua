local hxdx = require("hxdx")

local world = hxdx.newWorld({
  gravity_y = 0
})

-- Load in collision classes
require('src.config.COLLISIONS')(world)

return world
