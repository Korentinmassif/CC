require "src/button"

Monitor = {}
Monitor.__index = Monitor

function Monitor.new()
    local self = setmetatable({}, Monitor)
    self.mon = peripheral.find("monitor")
    self.buttons = {}
    self.backgrounds = {} 
    return self
end

function Monitor:addButton(...)
    table.insert(self.buttons, ...)
end

function Monitor:getButtonAt(x, y)
    for _, button in pairs(self.buttons) do
        if x >= button.x and x < button.x + button.width and
           y >= button.y and y < button.y + button.height then
            return button
        end
    end
    return nil
end

function Monitor:addBackground(...)
    table.insert(self.backgrounds, ...)
end

function Monitor:setBackground(color)
    self.mon.setBackgroundColor(color)
    self.mon.setTextColor(color)
    local w, h = self.mon.getSize()

    for y = 1, h do
        self.mon.setCursorPos(1, y)
        self.mon.write((" "):rep(w))
    end
end

function Monitor:clear()
    self.mon.setBackgroundColor(colors.black) -- ou une autre couleur par défaut
    self.mon.setTextColor(colors.white)       -- optionnel
    self.mon.clear()
end

function Monitor:loadConfig(config)
    for _, bg in ipairs(config.background) do
        self:addBackground(bg)
    end

    -- Ajout des boutons
    for _, btn in ipairs(config.buttons) do
        self:addButton(btn)
    end
end

function monitor:flush()
    self.buttons = {}
    self.background = {}
end

function Monitor:draw()
    -- Appliquer un fond propre
    self:setBackground(colors.black)  -- ou autre couleur de fond par défaut

    -- Dessiner les carrés de background personnalisés
    for _, bg in ipairs(self.backgrounds) do
        self.mon.setBackgroundColor(bg.color)
        for i = 0, bg.height - 1 do
            self.mon.setCursorPos(bg.x, bg.y + i)
            self.mon.write((" "):rep(bg.width))
        end
    end

    -- Dessiner les boutons
    for _, button in pairs(self.buttons) do
        local x, y = button.x, button.y
        local width, height = button.width, button.height

        -- Bordure
        self.mon.setBackgroundColor(button.bdColor)
        for i = 0, height - 1 do
            self.mon.setCursorPos(x, y + i)
            self.mon.write((" "):rep(width))
        end

        -- Intérieur
        self.mon.setBackgroundColor(button.bgColor)
        for i = 1, height - 2 do
            self.mon.setCursorPos(x + 1, y + i)
            self.mon.write((" "):rep(width - 2))
        end

        -- Texte
        if button.label then
            local labelX = x + math.floor((width - #button.label) / 2)
            local labelY = y + math.floor(height / 2)
            self.mon.setCursorPos(labelX, labelY)
            self.mon.setTextColor(button.txColor)
            self.mon.write(button.label)
        end
    end
end



