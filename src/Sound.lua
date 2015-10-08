local tessound = require('libs.TESound')

-- GLOBALS
SOUNDS = {
  HIT = 'assets/sounds/Hit.wav',
  JUMP = 'assets/sounds/Jump2.wav',
  FALL = 'assets/sounds/FallInWater.wav',
  SWALLOW = 'assets/sounds/Swallow.wav',
  SPIT = 'assets/sounds/Spit.wav',
  SLIP = 'assets/sounds/Slip.wav',
  POSITIVE = 'assets/sounds/PositiveSound.wav',
  NEGATIVE = 'assets/sounds/NegativeSound.wav',
  MENU_SELECT = 'assets/sounds/MenuNavigationForwards.wav',
  MENU_UNSELECT = 'assets/sounds/MenuNavigationBackWards.wav',
  MENU = 'assets/sounds/MenuMusicwithoutDrums.wav',
  END = 'assets/sounds/EndGameMusic.wav',
  INTRO = 'assets/sounds/IntroOrWin.wav',
  MENU_DRUMS = 'assets/sounds/MusicMenu.wav',
  TIME = 'assets/sounds/MusicBattleRunningOutOfTime.wav',
  BATTLE = 'assets/sounds/MusicMainBattleTheme.wav',
}

local Sounds = class('Sounds')

function Sounds.play(soundName, ...)
  TEsound.play(soundName, ...)
end

function Sounds.stop()
  TEsound.stop('loop')
end

function Sounds.pause()
  TEsound.pause('loop')
end

function Sounds.resume()
  TEsound.resume('loop')
end

function Sounds.loop(soundNames)
  TEsound.stop('loop')
  TEsound.playLooping(soundNames, {'loop'})
end


return Sounds
