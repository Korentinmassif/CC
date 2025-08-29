Button = {}
Button.__index = Button
-- Btton.new("label", 5, 5, 10, 3, ...)
function Button.new(label, x, y, width, height, bgColor, bdColor, txColor)
    local self = setmetatable({}, Button)
    self.label = label
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.bgColor = bgColor
    self.bdColor = bdColor
    self.txColor = txColor
    return self
end
