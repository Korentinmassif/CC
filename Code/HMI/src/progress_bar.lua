ProgressBar = {}
ProgressBar.__index = Button

function ProgressBar:getFilling(fill)
    if fill < 0 then fill = 0 end
    if fill > 100 then fill = 100 end

    self.fill = fill
    self.widthFill = math.ceil(self.width * fill / 100) -- Calcul de la largeur du remplissage
    self.widthBg = self.width - self.widthFill -- Calcul de la largeur du fond
end

function ProgressBar.new(fill, x, y, width, height, bgColor, fillColor)
    local self = setmetatable({}, ProgressBar)
    self.x = x
    self.y = y
    self.width = width 
    self.height = height
    self.bgColor = bgColor
    self.fillColor = fillColor
    self.fill = nil
    self.widthFill = nil
    self.widthBg = nil


    self.fill = fill or 0 -- Si fill est nil, on met 0
    self:getFilling(self.fill)

    return self
end
