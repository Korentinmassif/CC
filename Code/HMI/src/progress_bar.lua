ProgressBar = {}
ProgressBar.__index = ProgressBar

function ProgressBar:getFilling(fill)
    if fill < 0 then fill = 0 end
    if fill > 100 then fill = 100 end

    self.fill = fill
    self.widthFill = math.ceil(self.width * fill / 100)
    self.widthBg = self.width - self.widthFill
end

function ProgressBar.new(fill, x, y, width, height, bgColor, fillColor)
    local self = setmetatable({}, ProgressBar)  -- Création de l'objet avec la métatable ProgressBar
    
    -- Initialisation des propriétés
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.bgColor = bgColor
    self.fillColor = fillColor

    -- Valeur par défaut pour 'fill' si non spécifié
    self.fill = fill or 0
    self:getFilling(self.fill)  -- Appel de la méthode getFilling pour calculer les dimensions

    return self
end
