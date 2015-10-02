local ui_path = ... .. '.'
local UI = {}
require(ui_path .. 'utf8-l')
UI.Object = require(ui_path .. 'classic.classic')
UI.Input = require(ui_path .. 'input.Input')
UI.Text = require(ui_path .. 'popo.Text')
UI.Math = require(ui_path .. 'mlib.mlib')

UI.keypressed = function(key) 
    for _, t in ipairs(UI.elements) do
        t.input:keypressed(key)
    end
end
UI.keyreleased = function(key) 
    for _, t in ipairs(UI.elements) do
        t.input:keyreleased(key)
    end
end
UI.mousepressed = function(x, y, button) 
    for _, t in ipairs(UI.elements) do
        t.input:mousepressed(x, y, button)
    end
end
UI.mousereleased = function(x, y, button) 
    for _, t in ipairs(UI.elements) do
        t.input:mousereleased(x, y, button)
    end
end
UI.gamepadpressed = function(joystick, button) 
    for _, t in ipairs(UI.elements) do
        t.input:gamepadpressed(joystick, button)
    end
end
UI.gamepadreleased = function(joystick, button) 
    for _, t in ipairs(UI.elements) do
        t.input:gamepadreleased(joystick, button)
    end
end
UI.gamepadaxis = function(joystick, axis, value)
    for _, t in ipairs(UI.elements) do
        t.input:gamepadaxis(joystick, axis, value)
    end
end 
UI.textinput = function(text)
    for _, t in ipairs(UI.elements) do
        if t.textinput then
            t:textinput(text)
        end
    end
end

UI.registerEvents = function()
    local callbacks = {'keypressed', 'keyreleased', 'mousepressed', 'mousereleased', 'gamepadpressed', 'gamepadreleased', 'gamepadaxis', 'textinput'}
    local old_functions = {}
    local empty_function = function() end
    for _, f in ipairs(callbacks) do
        old_functions[f] = love[f] or empty_function
        love[f] = function(...)
            old_functions[f](...)
            UI[f](...)
        end
    end
end

UI.uids = {}
UI.getUID = function(id) 
    if id then
        if not UI.uids[id] then
            UI.uids[id] = true
            return id
        else 
            error("id conflict: #" .. id) 
        end
    else
        local i = 1
        while true do
            if not UI.uids[i] then
                UI.uids[i] = true
                return i
            end
            i = i + 1
        end
    end
end
UI.elements = setmetatable({}, {__mode = 'v'})
UI.addToElementsList = function(element)
    table.insert(UI.elements, element)
    return UI.getUID()
end
UI.removeFromElementsList = function(id)
    for i, element in ipairs(UI.elements) do
        if element.id == id then
            table.remove(UI.elements, i) return
        end
    end
end

UI.DefaultTheme = nil
applyDefaultTheme = function(ui_element_type, ...)
    if not UI.DefaultTheme then return unpack({...}) end
    args = {...}
    if not args[5] then args[5] = {} end
    if args[5] and type(args[5]) == 'table' then
        if not args[5].extensions then args[5].extensions = {UI.DefaultTheme[ui_element_type]} end
    end
    return unpack(args)
end

local Button = require(ui_path .. 'Button')
UI.Button = function(...) return Button(UI, applyDefaultTheme('Button', ...)) end
local Checkbox = require(ui_path .. 'Checkbox')
UI.Checkbox = function(...) return Checkbox(UI, applyDefaultTheme('Checkbox', ...)) end
local Frame = require(ui_path .. 'Frame')
UI.Frame = function(...) return Frame(UI, applyDefaultTheme('Frame', ...)) end
local Scrollarea = require(ui_path .. 'Scrollarea')
UI.Scrollarea = function(...) return Scrollarea(UI, applyDefaultTheme('Scrollarea', ...)) end
local Slider = require(ui_path .. 'Slider')
UI.Slider = function(...) return Slider(UI, applyDefaultTheme('Slider', ...)) end
local Textarea = require(ui_path .. 'Textarea')
UI.Textarea = function(...) return Textarea(UI, applyDefaultTheme('Textarea', ...)) end

return UI
