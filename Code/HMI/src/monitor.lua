require"./button.lua"

Monitor = {}
Monitor.__index = Monitor

function Monitor.new(label)
    local self = setmetatable({}, Monitor)
    self.mon = peripheral.find("monitor")
    self.buttons = {}
    return self
end

Monitor:addButton(button)
    table.insert(self.buttons, button)
end

Monitor:draw()
    for k, button in pairs(self.buttons) do
        self.mon.setBackgroundColor(button.bdColor)
        for i = 0, height - 1 do
            mon.setCursorPos(x, y + i)
            mon.write((" "):rep(width))
        end

    -- Dessiner l'intérieur du bouton (1 pixel en moins sur chaque bord)
        mon.setBackgroundColor(button.bgColor)
        for i = 1, height - 2 do
            mon.setCursorPos(x + 1, y + i)
            mon.write((" "):rep(width - 2))
        end

    -- Afficher le texte centré
        if button.label then
            local labelX = x + math.floor((width - #label) / 2)
            local labelY = y + math.floor(height / 2)
            mon.setCursorPos(labelX, labelY)
            mon.setTextColor(button.txColor)
            mon.write(label)
        end
    end
end