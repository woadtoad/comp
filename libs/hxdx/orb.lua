function PhysActor:CalculateOrbit()
--This function derives everything you need to know about a single orbiting body.

         local bodyPos = Vector.new(self.body:getPosition())
         local bodyVel = Vector.new(self.body:getLinearVelocity())      

         local celPos = Vector.new(self.currentCelestialB.body:getPosition())      

         --get the velocity of the body
         local V = bodyVel:length()      

         --get the distance from the foci
         local R = bodyPos:distanceTo(celPos)      

         --Get the Zenith Angle
         local Anglefrombody  =  bodyPos:angleTo(celPos)
         local bodyFromAngle  =  celPos:angleTo(bodyPos)
         local Angle = math.deg( math.atan2(bodyVel.y,bodyVel.x))
         local Zenith =  Angle - Anglefrombody
         local GM = (constant * self.currentCelestialB.body.fakeMass)
   

         -- tan V  = (r1 × v12 / GM) × sin  × cos  / [(r1 × v12 / GM) × sin2  - 1
         --tanV = (6628140*math.pow(7900,2)/3.986005e14) * math.sin(math.rad(89)) * math.cos(math.rad(89)) / ((6628140*math.pow(7900,2)/3.986005e14) * math.pow(math.sin(math.rad(89)),2) - 1)
         -- this formula is to locate where the body is from the perrigee
         local tanVx = (R*math.pow(V,2)/GM) * math.sin(math.rad(Zenith)) * math.cos(math.rad(Zenith))
         local tanVy =  ((R*math.pow(V,2)/GM) * math.pow(math.sin(math.rad(Zenith)),2) - 1)
         local tanV = math.atan2(tanVx,tanVy)

         local tanVDeg = math.deg(tanV)
         local PerigeeFromZeroAngle =  bodyFromAngle - ( tanVDeg - 180) --WOOO!
         local PerigeeFromZeroAngle =  bodyFromAngle -  tanVDeg  --WOOO

         local C = (2 * GM) / (R* math.pow(V,2))

         local Rh = (-C + math.sqrt( math.pow(C,2) - 4 * (1-C) * -math.pow(math.sin(math.rad(Zenith)),2) )) / (2*(1-C))
         local Rl = (-C - math.sqrt( math.pow(C,2) - 4 * (1-C) * -math.pow(math.sin(math.rad(Zenith)),2) )) / (2*(1-C))      
      
         local Rlower = math.min(Rh,Rl)
         local Rhigher = math.max(Rh,Rl)      

         local PerigeeRadius = R * Rlower
         local ApogeeRadius = R * Rhigher      

         --Eccentricity
         --e = SQRT[ (r1 × v12 / GM - 1)2 × sin2  + cos2  ]
         local E = math.sqrt( math.pow((R * math.pow(V,2)/ GM -1),2) * math.pow(math.sin(math.rad(Zenith)),2) + math.pow(math.cos(math.rad(Zenith)),2))      


         --SEMI MAJOR AXIS
         --a = 1 / ( 2 / r1 - v12 / GM )      

         local SemiMajorAxis = 1/(2 / R - math.pow(V,2) / GM)

         --theta = E * math.sin(math.rad(225)) /  (1 + E * math.cos(math.rad(225)))
         --theta = 0.1 * math.sin(math.rad(225)) /  (1 + 0.1 * math.cos(math.rad(225)))
         --theta = math.atan(theta)      

 
          self.predictedPoints = {}
          self.predictedPoints2 = {}      
          self.perigee = {}
          self.currentAng = {}

         -- print("Vel:"..V)
         -- print("initDist"..R)
         --print("perigeeFromZero:"..PerigeeFromZeroAngle,tanVDeg)
         -- print("eccentricity:"..E)
         -- print("PerigeeRadius:"..PerigeeRadius)
         -- print("ApogeeRadius:"..ApogeeRadius)
         -- print("SemiMajorAxis:"..SemiMajorAxis)
         -- print("C:"..C)
         -- print("Zenith:"..Zenith)
         -- print("Velocity:"..V)

         self.perigee[1] = 0
         self.perigee[2] = 0   
         self.perigee[3] = math.cos(math.rad(PerigeeFromZeroAngle))*(PerigeeRadius)
         self.perigee[4] = math.sin(math.rad(PerigeeFromZeroAngle))*(PerigeeRadius)

         self.currentAng[1] = 0
         self.currentAng[2] = 0   
         self.currentAng[3] = math.cos(math.rad(PerigeeFromZeroAngle+tanVDeg))*(PerigeeRadius)
         self.currentAng[4] = math.sin(math.rad(PerigeeFromZeroAngle+tanVDeg))*(PerigeeRadius)


         for i=1,361 do
            Vang = i

            --V is angle from perrigee      

            PointDist = SemiMajorAxis * (1- math.pow(E,2)) / (1+ E * math.cos(math.rad(Vang)))      
      
            PointAngle =   Vang +  PerigeeFromZeroAngle
            --PointAngle =   Vang

            Point = Vector.new(PointDist*math.cos(math.rad(PointAngle)),PointDist*math.sin(math.rad(PointAngle)))      

            table.insert(self.predictedPoints,Vang+800)
            table.insert(self.predictedPoints,PointDist/10)
            table.insert(self.predictedPoints2,Point.x)
            table.insert(self.predictedPoints2,Point.y)   

         end      
      
end