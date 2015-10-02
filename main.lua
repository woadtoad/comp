
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

-- Setup our UI framework with a offshelf theme
UI.DefaultTheme = require('thranduil.Theme')

-- Initialises Camera
local Camera = require('src.Camera')

local SCENES = require('src.SCENES')
-- Our singleton SceneManager bootstraps the scenes from ./src/scenes/
local SceneManager = require('src.SceneManager')
SceneManager:init()

-- Start the game in the menu
SceneManager:gotoState(SCENES.GAME)


local input = require('src.Input')
require('src.INPUTS')(input) -- Initialise bindings

-- Start the game loops
function love.load()
  UI.registerEvents()
  Camera:setScale(DEBUG.ZOOM)
end

function love.update(dt)
  SceneManager:update(dt)

  -- Our input functions will handle boipushy events
  SceneManager:input(input)
end

function love.draw()
  SceneManager:draw()
end

function love.keypressed(key, isrepeat)
  SceneManager:keypressed(key, isrepeat)
end
