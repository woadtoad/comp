-- Setup the camera to user in love
local Camera = require('gamera.gamera')

-- We make the canvas very large so we can effectively use zoom
-- to debug
local canvas = 5000

local camera = Camera.new(-canvas, -canvas, canvas*2, canvas*2)
camera:setScale(DEBUG.ZOOM)

-- Camera is a singleton, since we'll only have one to begin
-- When we need more cameras (if multiplayer requires it) then
-- we need to create a CameraManger
return camera
