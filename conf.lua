-- Enable console output
io.stdout:setvbuf("no")

-- Setup seed for random functions
math.randomseed(os.clock ())

function love.conf(t)

  t.identity = "WoadToadArena"                -- The name of the save directory (string)
  t.version = "0.9.2"                         -- The LÖVE version this game was made for (string)
  t.console = false                           -- Attach a console (boolean, Windows only)

  -------------------------------
  -- Used for love-relase

  -- The version of your game (string)
  t.game_version = 0.1
  -- The path to the executable icons (string)
  t.icon = "assets/woadtoad-icon.png"
  -- Attach a console (boolean, Windows only)
  t.console = false
  -- The name of the game (string)
  t.title = "Woad Toad Arena"
  -- The name of the author (string)
  t.author = "Woad Toad"
  -- The email of the author (string)
  t.email = "lochlanbunn@gmail.com"
  -- The website of the game (string)
  t.url = "http://twitter.com/woadtoad"
  -- The description of the game (string)
  t.description = "Multiplayer skirmish, starring JUICY MEATS and DANGEROUS ICE"

  -- OS to release your game on. Use a table if you want to overwrite the options, or just the OS name.
  -- Available OS are "love", "windows", "osx", "debian" and "android".
  -- A LÖVE file is created if none is specified.
  t.os = {
      "love",
      windows = {
          x32       = true,
          x64       = true,
          installer = false,
          appid     = 'woadtoadarena',
      },
      "osx",
      -- "debian",
      -- "android",
  }
  -------------------------------

  t.window.title = "Woad Toad Arena "         -- The window title (string)
  t.window.icon = "assets/woadtoad-icon.png"  -- Filepath to an image to use as the window's icon (string)
  t.window.width = 1440                       -- The window width (number)
  t.window.height = 900                       -- The window height (number)
  t.window.borderless = false                 -- Remove all border visuals from the window (boolean)
  t.window.resizable = false                  -- Let the window be user-resizable (boolean)
  t.window.minwidth = 1                       -- Minimum window width if the window is resizable (number)
  t.window.minheight = 1                      -- Minimum window height if the window is resizable (number)
  t.window.fullscreen = false                 -- Enable fullscreen (boolean)
  t.window.fullscreentype = "normal"          -- Choose between "normal" fullscreen or "desktop" fullscreen mode (string)
  t.window.vsync = true                       -- Enable vertical sync (boolean)
  t.window.fsaa = 0                           -- The number of samples to use with multi-sampled antialiasing (number)
  t.window.display = 1                        -- Index of the monitor to show the window in (number)
  t.window.highdpi = true                     -- Enable high-dpi mode for the window on a Retina display (boolean)
  t.window.srgb = false                       -- Enable sRGB gamma correction when drawing to the screen (boolean)
  t.window.x = nil                            -- The x-coordinate of the window's position in the specified display (number)
  t.window.y = nil                            -- The y-coordinate of the window's position in the specified display (number)

  t.modules.audio = true                      -- Enable the audio module (boolean)
  t.modules.event = true                      -- Enable the event module (boolean)
  t.modules.graphics = true                   -- Enable the graphics module (boolean)
  t.modules.image = true                      -- Enable the image module (boolean)
  t.modules.joystick = true                   -- Enable the joystick module (boolean)
  t.modules.keyboard = true                   -- Enable the keyboard module (boolean)
  t.modules.math = true                       -- Enable the math module (boolean)
  t.modules.mouse = true                      -- Enable the mouse module (boolean)
  t.modules.physics = true                    -- Enable the physics module (boolean)
  t.modules.sound = true                      -- Enable the sound module (boolean)
  t.modules.system = true                     -- Enable the system module (boolean)
  t.modules.timer = true                      -- Enable the timer module (boolean), Disabling it will result 0 delta time in love.update
  t.modules.window = true                     -- Enable the window module (boolean)
  t.modules.thread = true                     -- Enable the thread module (boolean)

end
