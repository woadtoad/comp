local SCENES = require('src.config.SCENES')

print('\nSceneManager\n------------\n')

-------------------------------
-- Setup the SceneManager class
-------------------------------

local SceneManager = class('SceneManager')
SceneManager:include(require('stateful'))

-- Gets a state from SceneManager, which is essentially a Scene
function SceneManager:getScene(sceneName)
  assert(SceneManager.static.states[sceneName] ~= nil, 'Requested scene, '..sceneName..', does not exist')
  return SceneManager.static.states[sceneName]
end

-- Gets a state from SceneManager, which is essentially a Scene
function SceneManager:current()
   local info = self:getStateStackDebugInfo()

   return info[1]
end

-- Requires all the files for the scenes
function SceneManager:init()
    -- Attach our scene logic
    for key,sceneName in pairs(SCENES) do
      print('  Initializing ' .. sceneName .. '...')
      require('src.scenes.' .. sceneName)(self:getScene(sceneName))
    end

    self:popAllStates()
end

-------------------------
-- Start scene management
-------------------------

-- Add out scenes states to the SceneManager,
-- so they're avaiable ASAP
for key,sceneName in pairs(SCENES) do
  SceneManager:addState(sceneName)
end


-- SceneManager is a singleton
local sceneManager = SceneManager:new()
return sceneManager
