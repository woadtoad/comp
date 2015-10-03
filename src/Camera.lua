-- Setup the camera to user in love
local Gamera = require('gamera.gamera')

local Camera = class('Camera')

function Camera:initialize ()
  -- We make the canvas very large so we can effectively use zoom
  -- to debug
  self.canvas = 5000

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

function Camera:draw()
end

-- Camera is a singleton, since we'll only have one to begin

return Camera:new()
