## Chatbox

A chatbox should behave like a normal chatbox you have on Steam, Skype or other messaging apps out there. You write text, press enter and the text is displayed on the screen. To achieve this, we'll use multiple Thranduil UI elements, tying them together however necessary.

To start, we'll create the `main.lua` file:

```lua
-- main.lua
Theme = require 'TestTheme'
UI = require 'UI'

function love.load()
  UI.registerEvents()
end
```

We simply load the UI module as well as the main theme. I'll use the `TestTheme.lua` file that you can find on this library's main directory. We can then create the Chatbox object:

```lua
-- Chatbox.lua
local Chatbox = UI.Object:extend()

function Chatbox:new(x, y, w, h)

end

function Chatbox:update(dt)

end

function Chatbox:draw()

end

return Chatbox
```

For OOP here I'm using [Classic](https://github.com/rxi/classic/), which can be accessed via `UI.Object`. But you can use any OOP library you want, or you don't even need to use one, just a table that can hold some variables should do. Then we can add this to `main.lua`:

```lua
Theme = require 'TestTheme'
UI = require 'ui/UI'
Chatbox = require 'Chatbox'

function love.load()
  UI.registerEvents()
  chatbox = Chatbox(10, 200, 300, 390)
end

function love.update(dt)
  chatbox:update(dt)
end

function love.draw()
  chatbox:draw()
end
```

And now we can start defining the Chatbox object. For starters, let's create a Frame. This Frame will hold both Textareas (textinput and the chat screen) as well as the send button.

```lua
function Chatbox:new(x, y, w, h)
  self.w, self.h = w, h
  self.main_frame = UI.Frame(x, y, w, h, {extensions = {Theme.Frame}, draggable = true, drag_margin = 20})
end

function Chatbox:update(dt)
  self.main_frame:update(dt)
end

function Chatbox:draw()
  self.main_frame:draw()
end
```

This should give you a draggable frame. To add the chat textarea we need to consider that this area will have to be scrollable, since every time an enter key is pressed it adds the text inputted into a new line. So, we first need to add a Scrollarea:

```lua
function Chatbox:new(x, y, w, h)
  ...
  self.scrollarea = UI.Scrollarea(5, 25, w - 10, h - 70, {extensions = {Theme.Scrollarea}, scrollbar_button_extensions = {Theme.Button}, area_width = w - 10, area_height = h - 70, show_scrollbars = true})
  self.main_frame:addElement(self.scrollarea)
end
```

We create the Scrollarea and add it to the frame. The positions and sizes used were achieved via testing to see what looked better. But generally the idea is to add things so that they have some spacing between them. For instance, the Scrollarea's x, y position is `5, 25`, which results in 5 pixels of spacing to the left and 5 pixels of spacing to the top (since there's a 20 pixels big in height drag bar on top of the frame).

Now we can add the Textarea to the Scrollarea:

```lua
function Chatbox:new(x, y, w, h)
  ...
  self.textarea = UI.Textarea(0, 0, w - 10, h - 70, {extensions = {Theme.Textarea}, text_margin = 5, editing_locked = true})
  self.scrollarea:addElement(self.textarea)
end
```

The Textarea has the same size as the Scrollarea and is added exactly on top of it. Both elements are supposed to be visually the same and act as one, we just need them to be both because the Textarea itself is not scrollable. We also set the `editing_locked` setting on the Textarea to true because the chat screen is not supposed to be editable at all.

We now can add the textinput Textarea:

```lua
function Chatbox:new(x, y, w, h)
  ...
  self.textinput = UI.Textarea(5, 25 + h - 70, w - 50, h, {extensions = {Theme.Textarea}, single_line = true, text_margin = 4})
  self.main_frame:addElement(self.textinput)
end
```

The textinput object is simply a Textarea with a single line. We create it and add it to the main Frame at the appropriate position (below the chat screen). Now we should be able to type text into the textinput area but we can't add it to the chat screen. To do that we need to check if enter has been pressed, take the textinput text (also delete it) and add it to the chat screen Textarea:

```lua
function Chatbox:update(dt)
  if self.textinput.input:pressed('enter') then
    local text = self.textinput:getText()
    if #text > 0 then
      -- Add textinput's text to the textarea
      local chat_text = os.date("%H:%M") .. ': ' .. text .. '\n'
      self.textarea:addText(chat_text)

      -- Delete textinput's text
      self.textinput:selectAll()
      self.textinput:delete()
    end
  end

  self.main_frame:update(dt)
end
```

This should make it so that pressing enter achieves the desired behavior. There's one thing to note here which is the use of `self.textinput.input`. Each UI element has an `input` attribute that can be checked in terms of key presses, releases or if they're down. The actions that can be checked are always described in the documentation with the `:bind` method. Anyway, the most important thing to remember is that those checks should come **before** the element is updated in the update function or they won't work. This is an implementation detail that leaked but I'm not sure how to fix it, so just keep it in mind.

You'll notice that there are a few problems though, one of which is that if you try moving the textinput cursor around with the left or right arrow keys sometimes the textinput object will lose its focus. This is happening because the Container mixin, by default, enables the use of arrow keys to select child objects. To disable this you should set the `disable_directional_selection` attribute to true on the Frame's creation. And to add to that, if you want the same thing to not be possible when you press TAB, you can set `disable_tab_selection` to true as well.

The second problem is that if you add a lot of new lines to the chat screen, once it goes over the Scrollarea/Textarea's height nothing happens. This is because the Scrollarea's scrolling functions aren't being activated. Usually scrolling is activated when the Scrollarea's width/height (`.w, .h` attributes) become bigger than its `area_width` or `area_height` attributes. If you go back to the Scrollarea's creation you'll notice those attributes have matching sizes, the same goes for the Textarea. So you need to manually make it so that their heights are changed whenever the height of text lines goes above the maximum height:

```lua
function Chatbox:update(dt)
  if self.textinput.input:pressed('enter') then
    ...
    -- Scrolling
    if self.textarea:getMaxLines()*self.textarea.font:getHeight() > self.scrollarea.area_height then
      self.scrollarea.vertical_scrolling = true
      self.scrollarea.h = self.textarea:getMaxLines()*self.textarea.font:getHeight() + 4*self.textarea.text_margin
      self.textarea.h = self.textarea:getMaxLines()*self.textarea.font:getHeight() + 4*self.textarea.text_margin
    end
    ...
  end
end
```

And with this we make it so that whenever we add a new line to the textarea that makes its height go beyond the `area_height` value, we match both Scrollarea's and Textarea's height to be slightly above that value and also set Scrollarea's vertical scrolling to true. When this happens the scrollbars will show up. You may notice that they're in the wrong position. You can fix this by changing the `area_width` value on Scrollarea creation to `w - 10 - 15`. This will bring them a bit to the left but also make the Scrollarea's width smaller than `area_width`, which will make the horizontal scrollbars show up. You can remove them by saying `self.scrollarea.horizontal_scrolling = false`. Another thing you might wanna do is make sure that the screen automatically scrolls down as new text is added. To do this we can add `self.scrollarea:scrollDown(100)` to the end of the the scrolling conditional.
