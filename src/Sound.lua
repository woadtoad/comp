local tessound = require('TESound')

-- GLOBALS
SOUNDS = {
  HIT = 'assets/sounds/Hit.wav',
  JUMP = 'assets/sounds/Jump.wav',
  FALL = 'assets/sounds/FallInWater.wav',
  SWALLOW = 'assets/sounds/Swallow.wav',
  SPIT = 'assets/sounds/Spit.wav',
  SLIP = 'assets/sounds/Slip.wav',
  POSITIVE = 'assets/sounds/PositiveSound.wav',
  MENU_DRUMS = 'assets/sounds/MenuMusicwithoutDrums.wav',
  END = 'assets/sounds/EndGameMusic.wav',
  INTRO = 'assets/sounds/IntroOrWin.wav',
  MENU = 'assets/sounds/MusicMenu.wav',
  TIME = 'assets/sounds/MusicBattleRunningOutOfTime.wav',
  BATTLE = 'assets/sounds/MusicMainBattleTheme.wav',
}

local Sounds = class('Sounds')

function Sounds.play(soundName)
  TEsound.play(soundName)
end

function Sounds.loop(soundNames)
  TEsound.stop('loop')
  TEsound.playLooping(soundNames, 'loop')
end


return Sounds