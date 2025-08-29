require "./button.lua"

Monitor = {}
Monitor.__index = Monitor

function Monitor.new()
    local self = setmetatable({}, Monitor)
    self.mon = peripheral.find("monitor")
    self.buttons = {}
    return self
end

function Monitor:addButton(...)
    table.insert(self.buttons, ...)
end

function Monitor:setBackground(color)
    self.mon.setBackgroundColor(color)
    self.mon.setTextColor(color) -- aussi au cas où il y a du texte
    local w, h = self.mon.getSize()

    for y = 1, h do
        self.mon.setCursorPos(1, y)
        self.mon.write((" "):rep(w))
    end
end

function Monitor:draw()
    self.mon.clear()
    for _, button in pairs(self.buttons) do
        local x, y = button.x, button.y
        local width, height = button.width, button.height

        self.mon.setBackgroundColor(button.bdColor)
        for i = 0, height - 1 do
            self.mon.setCursorPos(x, y + i)
            self.mon.write((" "):rep(width))
        end

        self.mon.setBackgroundColor(button.bgColor)
        for i = 1, height - 2 do
            self.mon.setCursorPos(x + 1, y + i)
            self.mon.write((" "):rep(width - 2))
        end

        if button.label then
            local labelX = x + math.floor((width - #button.label) / 2)
            local labelY = y + math.floor(height / 2)
            self.mon.setCursorPos(labelX, labelY)
            self.mon.setTextColor(button.txColor)
            self.mon.write(button.label)
        end
    end
end
