DEBUG = {
  MODE = 0, -- SHOW_GAME
  MODES = {
    SHOW_GAME = 0,
    SHOW_GAME_AND_COLLISION = 1,
    SHOW_ONLY_COLLISION = 2
  },
  ZOOM = 1
}

-- Construct
local args = {}
for i=2,(#arg) do
  table.insert(args, arg[i])
end

for i,cliArg in ipairs(args) do
  if string.find(cliArg, '^--debug') ~= nil then
    local optionArg = tonumber(string.match(cliArg, '^--debug=(%d)'))

    DEBUG.MODE = optionArg or DEBUG.MODES.SHOW_GAME_AND_COLLISION
  end

  if string.find(cliArg, '^--zoom') ~= nil then
    local optionArg = tonumber(string.match(cliArg, '^--zoom=(%d%.?%d?)'))

    DEBUG.ZOOM = optionArg or 0.5
  end
end

print('\nDebug\n------------\n')
print('DEBUG.MODE: ' .. require('src.util').getkeyfromvalue(DEBUG.MODES, DEBUG.MODE))
print('DEBUG.ZOOM: ' .. DEBUG.ZOOM .. '\n')
