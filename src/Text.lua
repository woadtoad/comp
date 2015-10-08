local _ = require('libs.lume')

local Text = class('Text')
Text:include(require('libs.stateful'))

Text.static.FONT_FAMILIES = {
  main = 'assets/fonts/Snowstorm.otf'
}
Text.static.FONT_SIZES = {
  sm = 14,
  md = 20,
  lg = 32,
  xlg = 48,
  xxlg = 120,
}

-- Collections of love2d fonts
-- Text.static.FONTS['main']['md']
Text.static.FONTS = {}
Text.static.FONTS['debug'] = love.graphics.getFont()
for family,path in pairs(Text.static.FONT_FAMILIES) do
  Text.static.FONTS[family] = {}
  for sizeName,size in pairs(Text.static.FONT_SIZES) do
    Text.static.FONTS[family][sizeName] = love.graphics.newFont(path, size);
  end
end

function Text:initialize()
end

function Text.print(family, size, text, x, y, ...)
  love.graphics.setFont(Text.static.FONTS[family][size])

  local r, g, b, a = love.graphics.getColor()

  -- Print the undershadow text
  love.graphics.setColor(0, 0, 0, 50 * (a / 255))
  love.graphics.printf(text, x + 1 * (Text.static.FONT_SIZES[size] / 50 + 1), y + 1 * (Text.static.FONT_SIZES[size] / 50 + 1), ...)

  -- Print the actual text
  love.graphics.setColor(r, g, b, a)
  love.graphics.printf(text, x, y, ...)
end

function Text.small(...)
  Text.print('main', 'sm', ...)
end

function Text.normal(...)
  Text.print('main', 'md', ...)
end

function Text.large(...)
  Text.print('main', 'lg', ...)
end

function Text.huge(...)
  Text.print('main', 'xlg', ...)
end

function Text.massive(...)
  Text.print('main', 'xxlg', ...)
end

function Text.debug(...)
  love.graphics.setFont(Text.static.FONTS['debug'])
  love.graphics.printf(...)
end



-- Most Text functions don't need to be called on an instance
return Text
