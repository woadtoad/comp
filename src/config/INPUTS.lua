-- GLOBAL
INPUTS = {
  MOVEX = 'movex',
  MOVEY = 'movey',
  LOBX = 'lobx',
  LOBY = 'loby',
  THROW = 'throw',
  JUMP = 'jump',
  EAT = 'eat',

  -- Menuish inputs
  PAUSE = 'pause',
  UNPAUSE = 'unpause',
  JOIN = 'join',
  NEW_GAME = 'newgame',
  RESTART = 'restart',

  -- Debugging
  ZOOM_OUT = 'zoomout',
  ZOOM_IN = 'zoomin',
  SWITCH_MODE = 'switchmode',
  RELOAD = 'reload',
}

return function(input)

  -- Setup input binding HERES

  -- Sticks
  input:bind('leftx', INPUTS.MOVEX)
  input:bind('lefty', INPUTS.MOVEY)
  input:bind('rightx', INPUTS.LOBX)
  input:bind('righty', INPUTS.LOBY)

  -- Buttons
  input:bind('r2', INPUTS.THROW)
  input:bind('l2', INPUTS.JUMP)
  input:bind('fdown', INPUTS.JUMP)
  input:bind('fright', INPUTS.EAT)

  -- Menuish buttons
  input:bind('back', INPUTS.RESTART)
  input:bind('start', INPUTS.PAUSE)
  input:bind('start', INPUTS.UNPAUSE)
  input:bind('start', INPUTS.NEW_GAME)
  input:bind('fdown', INPUTS.JOIN)

  -- Debugging
  input:bind('dpdown', INPUTS.ZOOM_OUT)
  input:bind('dpup', INPUTS.ZOOM_IN)
  input:bind('fleft', INPUTS.SWITCH_MODE)
  input:bind('fup', INPUTS.RELOAD)

end
