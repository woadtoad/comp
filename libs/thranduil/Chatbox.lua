local Chatbox = UI.Object:extend('Chatbox')

function Chatbox:new(x, y, w, h)
    UI.DefaultTheme = Theme
    self.main_frame = UI.Frame(x, y, w, h, {draggable = true, drag_margin = 20, disable_directional_selection = true, disable_tab_selection = true})
    self.scrollarea = UI.Scrollarea(5, 25, w - 10, h - 70, {scrollbar_button_extensions = {Theme.Button}, 
                                                            area_width = w - 10 - 15, area_height = h - 70, show_scrollbars = true})
    self.main_frame:addElement(self.scrollarea)

    self.textarea = UI.Textarea(0, 0, w - 10, h - 70, {text_margin = 5, editing_locked = true})
    self.scrollarea:addElement(self.textarea)

    self.textinput = UI.Textarea(5, 25 + h - 70 + 5, w - 50, h, {single_line = true, font = font, text_margin = 4})
    self.main_frame:addElement(self.textinput)

    self.send_button = UI.Button(w - 40, h - 40, 35, 35)
    self.main_frame:addElement(self.send_button)

    self.scrollarea.horizontal_scrolling = false
end

function Chatbox:update(dt)
    if self.textinput.input:pressed('enter') or self.send_button.pressed then
        local text = self.textinput.text.str_text
        if #text > 0 then
            -- Add textinput's text to the textarea
            local chat_text = os.date("%H:%M") .. ': ' .. text .. '\n'
            self.textarea:addText(chat_text)

            -- Scrolling
            if self.textarea:getMaxLines()*self.textarea.font:getHeight() > self.scrollarea.area_height then
                self.scrollarea.vertical_scrolling = true
                self.scrollarea.h = self.textarea:getMaxLines()*self.textarea.font:getHeight() + 4*self.textarea.text_margin
                self.textarea.h = self.textarea:getMaxLines()*self.textarea.font:getHeight() + 4*self.textarea.text_margin
                self.scrollarea:scrollDown(100)
            end

            -- Delete textinput's text
            self.textinput:selectAll()
            self.textinput:delete()
        end
    end

    self.main_frame:update(dt)
end

function Chatbox:draw()
    self.main_frame:draw()
end

return Chatbox
