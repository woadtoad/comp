toad = [[

                                 ,▄▄▄▄▄,
                             .▄▓█▀▀▀▀▀▀▀█▓▄
                           ▄██▀`         ╙▀██▄
                        ▄▓█▀└      ▄▓████▓▄.▀██
                      #█▀╙       ▓███.@████▀ ╙██
                    ▄█▀`    ▄▄, ██ ▀█▄, ,▄▄▓▓███"
                   ▓█▀      ▀▀" █▌  └▀▀▀▀▀▀▀╙██∩
                  ƒ█▀      .▄▄  ██           ▀█▌
                  ██    ██─╚██   ▀█▄          ╙█▌
                  ██             ╒███▓▄        ▐█
                  ███▓▓▓▓▄▄      ██" ╙▀█▓▄     ▐█
                  ██▓▄  ╙▀▀█▄   ╒██     ╙▀█▓▄ ▓█"
                  ╙███▀▓▄▄ └██ ▄█▀██▄     ▄████í
                    ▀█▓,,└  ║██▀   ▀▀██▓▓▄▄█████▄
                      ╙▀▀██████#▓▓▓▓███▀▀▀▀▀▀▀▀▀└

██╗    ██╗ ██████╗  █████╗ ██████╗     ████████╗ ██████╗  █████╗ ██████╗
██║    ██║██╔═══██╗██╔══██╗██╔══██╗    ╚══██╔══╝██╔═══██╗██╔══██╗██╔══██╗
██║ █╗ ██║██║   ██║███████║██║  ██║       ██║   ██║   ██║███████║██║  ██║
██║███╗██║██║   ██║██╔══██║██║  ██║       ██║   ██║   ██║██╔══██║██║  ██║
╚███╔███╔╝╚██████╔╝██║  ██║██████╔╝       ██║   ╚██████╔╝██║  ██║██████╔╝
 ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═════╝        ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═════╝

]]

-- Begin!
---------

-- Add libs/ and assets/entities to the require() path
-- package.path = './libs/?.lua;./libs/?/init.lua;./assets/entities/?.lua;' .. package.path

-- Checks before enabling debugging features
require('src.debug')

-- Enable classes as a global 'keyword'
class = require('libs.middleclass')

-- Following are suited to being globals
_ = require('libs.lume')
UI = require('libs.thranduil.ui')
ATLAS = require('libs.texmate.AtlasImporter').loadAtlasTexturePacker( 'assets.entities.entitiesC', 'assets/entities/entitiesC.png' )
UIROCKS = require('libs.texmate.AtlasImporter').loadAtlasTexturePacker( 'assets.entities.uirocks', 'assets/entities/uirocks.png' )
PINKATLAS = require('libs.texmate.AtlasImporter').loadAtlasTexturePacker( 'assets.entities.pink', 'assets/entities/pink.png' )
TEAMASSETS = require('libs.texmate.AtlasImporter').loadAtlasTexturePacker( 'assets.entities.TeamAssets', 'assets/entities/TeamAssets.png' )
ORANGEATLAS = require('libs.texmate.AtlasImporter').loadAtlasTexturePacker( 'assets.entities.orange', 'assets/entities/orange.png' )
GREENATLAS = require('libs.texmate.AtlasImporter').loadAtlasTexturePacker( 'assets.entities.green', 'assets/entities/green.png' )
BLUEATLAS = require('libs.texmate.AtlasImporter').loadAtlasTexturePacker( 'assets.entities.blue', 'assets/entities/blue.png' )

-- Setup our UI framework with a offshelf theme
UI.DefaultTheme = require('libs.thranduil.Theme')

-- Initialises Camera
local Camera = require('src.Camera')

local SCENES = require('src.config.SCENES')
-- Our singleton SceneManager bootstraps the scenes from ./src/scenes/
local SceneManager = require('src.SceneManager')
SceneManager:init()

-- Start the game in the menu
SceneManager:gotoState(SCENES.START)

local input

-- Start the game loops
function love.load()
  -- Exposes TEsound as a global var
  require('libs.TESound')

  UI.registerEvents()

  input = require('src.Input')
  require('src.config.INPUTS')(input) -- Initialise bindings

  Camera.parent:setScale(DEBUG.ZOOM)
end

function love.update(dt)
  -- Required by TEsound
  TEsound.cleanup()

  -- Our input functions will handle boipushy events
  if love.joystick.getJoystickCount() > 0 then
    SceneManager:input(input)
    input:update()
  end

  SceneManager:update(dt)
end

function love.draw()
  if DEBUG.MODE == DEBUG.MODES.SHOW_GAME or DEBUG.MODE == DEBUG.MODES.SHOW_GAME_AND_COLLISION then
    SceneManager:draw()
  end

  if DEBUG.MODE == DEBUG.MODES.SHOW_GAME_AND_COLLISION or DEBUG.MODE == DEBUG.MODES.SHOW_ONLY_COLLISION then
    SceneManager:ddraw()
  end
end

function love.keypressed(key, isrepeat)
  SceneManager:keypressed(key, isrepeat)
end
