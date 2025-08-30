ProgressBar = {}
ProgressBar.__index = Button

function ProgressBar.new(fill, x, y, width, height, bgColor, fillColor)
    self.x = x
    self.y = y
    self.width = width 
    self.height = height
    self.bgColor = bgColor
    self.fillColor = fillColor
    self.fill = nil
    self.widthFill = nil
    self.widthBg = nil
    self:getFilling(fill)
end

function ProgressBar:getFilling(fill)
    self.fill = fill
    self.widthFill = math.ceil(self.width * fill/100)
    self.widthBg = self.width - self.widthFill
end
