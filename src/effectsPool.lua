local Pool = class('pool')

function Pool:initialize(item,count,...)

  self.activeItemList = {}
  self.inactiveItemList = {}
  for i=1,count do

    --we need a key so that we are able to call the correct item back when we gotta deactivated a pool.

    local RanKey = "key" .. tostring(love.timer.getTime())
    table.insert(self.inactiveItemList,item:new(...))
    self.inactiveItemList[i].key = RanKey
  end

end

function Pool:makeActive(...)
  assert(self.inactiveItemList[1],"Pool too small")

  --checks for a method inside the class item and makes it active
  if self.inactiveItemList[1].makeActive then self.inactiveItemList[1]:makeActive() end

  --pushes to the active list so we can pass through draw and update
  local key = self.inactiveItemList[1].key
  self.activeItemList[self.inactiveItemList[1].key] = self.inactiveItemList[1]
  table.remove(self.inactiveItemList,1)
  return self.activeItemList[key]

end


function Pool:deactivate(key)

  table.insert(self.inactiveItemList,self.activeItemList[key])
  if self.activeItemList[key].deactivate then self.activeItemList[key]:deactivate() end
  self.activeItemList[key] = nil

end


function Pool:draw()

  for i,v in pairs(self.activeItemList) do
    self.activeItemList[v.key]:draw()
  end

end

function Pool:update(dt)

  for i,v in pairs(self.activeItemList) do
    self.activeItemList[v.key]:update(dt)
  end

end

return Pool
