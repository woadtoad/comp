-- Setup the camera to user in love
local Gamera = require('libs.gamera.gamera')

local Camera = class('Camera')

function Camera:initialize ()
  -- We make the canvas very large so we can effectively use zoom
  -- to debug
  self.canvas = 5000
  self.lerpAmt = .2

  self.parent = Gamera.new(-self.canvas, -self.canvas, self.canvas*2, self.canvas*2)

  self.shakertime = 1
  self.togoal = 1
  self.togoalshaker = 1
  self.initialx, self.intialy = self.parent:getPosition()
end

function Camera:moveTo(x,y,scale,time)
  self.animspeed = 1 / time
  self.togoal = 0
  self.time = love.timer.getTime or os.time
  self.initx,self.inity = self.parent:getPosition()
  self.goalx,self.goaly = x,y

end

function Camera:setScale(scale)
  self.parent:setScale(scale)

end


function Camera:shaker (magnitude,time)
  --magnitude is how much is shakes
  self.shakermag = magnitude
  self.togoalshaker = 0
  self.shakertime = 1 / time

end


function Camera:update(dt)
  local randx,randy = 0,0


  if self.togoalshaker < 1 then
     self.togoalshaker = self.togoalshaker + self.shakertime * dt

    self.shake = _.smooth( self.shakermag, 0,  self.togoalshaker)
  else

    self.shake = nil

  end

  if self.togoal < 1  then

    self.togoal = self.togoal + self.animspeed * dt

  end
    animposx = _.smooth( self.initx ,self.goalx , self.togoal)
    animposy = _.smooth( self.inity ,self.goaly , self.togoal)


  if self.shake then
    randx =  math.random(-self.shake,self.shake)
    randy =  math.random(-self.shake,self.shake)
  end


  self.parent:setPosition(animposx+randx,animposy+randy)
end

function Camera:follow(positions)
  local targetX, targetY = 0,0
  local prevX, prevY = self.parent:getPosition()
  for i, v in pairs(positions) do
    targetX = targetX + positions[i][1]
    targetY = targetY + positions[i][2]
  end
  targetX = targetX / #positions
  targetY = targetY / #positions
  targetX = _.lerp(targetX, prevX, self.lerpAmt)
  targetY = _.lerp(targetY, prevY, self.lerpAmt)
  self.parent:setPosition(targetX, targetY)
end

function Camera:draw()
end

-- Camera is a singleton, since we'll only have one to begin

return Camera:new()
