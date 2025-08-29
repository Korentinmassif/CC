Button = {}
Button.__index = Button

function Button.new(label, x, y, width, height, bgColor, bdColor, txColor)
    local self = setmetatable({}, Button)
    self.label = label
    self.x = x
    self.y = y
    self.widht = width
    self.h = height
    self.bgColor = bgColor
    self.bdColor = bdColor
    self.txColor = txColor
    return self
end
