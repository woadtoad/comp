-- base class for pickup --
local Pools = require("src.effectsPool")
local TexMate = require("texmate.TexMate")
local world = require('src.world')
local Pickup = class('Pickup')
local TexMateStatic = require('src.TexMateStatic')
Pickup:include(require('stateful'))

function Pickup:initialize()
  --frame = TexMateStatic:new("assets/entities/rockDirt.png",1,9,3,)}
end

function Pickup:update(dt)

end

function Pickup:draw()

end

