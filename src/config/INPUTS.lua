-- GLOBAL
INPUTS = {
  MOVEX = 'movex',
  MOVEY = 'movey',
  LOBX = 'lobx',
  LOBY = 'loby',
  THROW = 'throw',
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

end
