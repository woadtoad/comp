require('TESound')

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

-- Enable classes as a global 'keyword'
class = require('middleclass')

-- Following are suited to being globals
_ = require('lume')
UI = require('thranduil.ui')
ATLAS = require('texmate.AtlasImporter').loadAtlasTexturePacker( 'assets.entities.entitiesC', 'assets/entities/entitiesC.png' )
PROTOTYPEASSETS = require('texmate.AtlasImporter').loadAtlasTexturePacker( 'assets.entities.TileAssets', 'assets/entities/TileAssets.png' )
TEAMASSETS = require('texmate.AtlasImporter').loadAtlasTexturePacker( 'assets.entities.TeamAssets', 'assets/entities/TeamAssets.png' )
PINKATLAS = require('texmate.AtlasImporter').loadAtlasTexturePacker( 'assets.entities.pink', 'assets/entities/pink.png' )
ORANGEATLAS = require('texmate.AtlasImporter').loadAtlasTexturePacker( 'assets.entities.orange', 'assets/entities/orange.png' )
GREENATLAS = require('texmate.AtlasImporter').loadAtlasTexturePacker( 'assets.entities.green', 'assets/entities/green.png' )
BLUEATLAS = require('texmate.AtlasImporter').loadAtlasTexturePacker( 'assets.entities.blue', 'assets/entities/blue.png' )
-- Setup our UI framework with a offshelf theme
UI.DefaultTheme = require('thranduil.Theme')

-- Initialises Camera
local Camera = require('src.Camera')

local SCENES = require('src.config.SCENES')
-- Our singleton SceneManager bootstraps the scenes from ./src/scenes/
local SceneManager = require('src.SceneManager')
SceneManager:init()

-- Start the game in the menu
SceneManager:gotoState(SCENES.START)

local input = nils

-- Start the game loops
function love.load()
  UI.registerEvents()

  input = require('src.Input')
  require('src.config.INPUTS')(input) -- Initialise bindings

  Camera.parent:setScale(DEBUG.ZOOM)
end

function love.update(dt)
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
