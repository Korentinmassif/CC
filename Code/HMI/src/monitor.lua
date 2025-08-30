require "src/button"
require "src/progress_bar"

Monitor = {}
Monitor.__index = Monitor

function Monitor.new()
    local self = setmetatable({}, Monitor)
    self.mon = peripheral.find("monitor")
    self.buttons = {}
    self.backgrounds = {} 
    self.progressBar = {}
    self.rednetChannel = nil
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

function Monitor:addProgressBar(...)
    table.insert(self.progressBar, ...)
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
    for _, bg in ipairs(config.background or {}) do
        self:addBackground(bg)
    end

    -- Ajout des boutons
    for _, btn in ipairs(config.buttons or {}) do
        self:addButton(btn)
    end

    for _, pb in ipairs(config.progressBar or {}) do 
        self:addProgressBar(pb)
    end

    self.rednetChannel = config.rednetChannel
end

function Monitor:flush()
    self.buttons = {}
    self.backgrounds = {}
    self.rednetChannel = nil
end

function Monitor:draw()
    -- Appliquer un fond propre
    self:setBackground(colors.white)  -- ou autre couleur de fond par défaut

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

    -- Dessiner les ProgressBars
    for _, pb in ipairs(self.progressBars or {}) do
            -- Dessiner d'abord le fond (background)
        -- Dessiner la partie remplie (fill) en premier
        self.mon.setBackgroundColor(progressBar.fillColor)
        for i = 1, progressBar.widthFill do
            self.mon.setCursorPos(progressBar.x + i - 1, progressBar.y)
            self.mon.write(" ")  -- Un espace pour remplir la zone de la barre
        end

        -- Ensuite, dessiner la partie fond (background)
        self.mon.setBackgroundColor(progressBar.bgColor)
        for i = 1, progressBar.widthBg do
            self.mon.setCursorPos(progressBar.x + progressBar.widthFill + i - 1, progressBar.y)
            self.mon.write(" ")  -- Un espace pour remplir la zone de fond
        end
    end
end



