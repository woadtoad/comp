-- GLOBAL
INPUTS = {
  MOVEX = 'movex',
  MOVEY = 'movey',
  LOBX = 'lobx',
  LOBY = 'loby',
  THROW = 'throw',
  JUMP = 'jump',


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
  input:bind('fright', INPUTS.JUMP)

  -- Debugging
  input:bind('dpdown', INPUTS.ZOOM_OUT)
  input:bind('dpup', INPUTS.ZOOM_IN)
  input:bind('start', INPUTS.SWITCH_MODE)
  input:bind('back', INPUTS.RELOAD)

end
