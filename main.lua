
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
class = require("middleclass")

-- Following are suited to being globals
UI = require("thranduil.ui")
ATLAS = require("texmate.AtlasImporter").loadAtlasTexturePacker( "assets.entities.entitiesC", "assets/entities/entitiesC.png" )
PROTOTYPEASSETS = require("texmate.AtlasImporter").loadAtlasTexturePacker( "assets.entities.TileAssets", "assets/entities/TileAssets.png" )

-- Setup our UI framework with a offshelf theme
UI.DefaultTheme = require("thranduil.Theme")

local SCENES = require('src.SCENES')
-- Our singleton SceneManager bootstraps the scenes from ./src/scenes/
local SceneManager = require('src.SceneManager')
SceneManager:init()

-- Start the game in the menu
SceneManager:gotoState(SCENES.GAME)

local Camera = require('src.Camera')
local input = require('src.Input')
require('src.INPUTS')(input) -- Initialise bindings

-- Start the game loops
function love.load()
  UI.registerEvents()
  Camera:setScale(DEBUG.ZOOM) -- TODO: fix
end

function love.update(dt)
  SceneManager:update(dt)

  -- Our input functions will handle boipushy events
  SceneManager:input(input)
end

function love.draw()
  -- We only want the camera to draw the Game-like scenes
  if SceneManager:current() == SCENES.GAME then
    Camera:draw(
    function(l, t, w, h)
        SceneManager:draw()
      end
    )
  else
    SceneManager:draw()
  end
end

function love.keypressed(key, isrepeat)
  SceneManager:keypressed(key, isrepeat)
end
