Camera = require("src.Camera")

local camerac = class('camerac')

function camerac:initialize ()
  self.shakertime = 1
  self.togoal = 1
  self.togoalshaker = 1
  self.initialx, self.intialy = Camera:getPosition()
end

function camerac:moveTo(x,y,scale,time)
  self.animspeed = 1 / time
  self.togoal = 0
  self.time = love.timer.getTime or os.time
  self.initx,self.inity = Camera:getPosition()
  self.goalx,self.goaly = x,y

end

function camerac:shaker (magnitude,time)
  --magnitude is how much is shakes
  self.shakermag = magnitude
  self.togoalshaker = 0
  self.shakertime = 1 / time

end


function camerac:update(dt)
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


  Camera:setPosition(animposx+randx,animposy+randy)


end

function camerac:draw()

end

return camerac
