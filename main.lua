dofile(shell.resolve("fonction.lua"))
monitorMid = 39.5
monitor = peripheral.wrap("right")
minecolony = peripheral.wrap("left")

display.setMonitor(monitor)
colony.setColony(minecolony)

while true do
  display.clear()
  display.setCursorPos(1, 1)
  display.writeLine(colony.getName(), "centered")
  secondBuilder = false
  req = colony.getBuilderJob()
  for builder, items in pairs(req) do
    x, y = display.getCursorPos()
    if y != 2 then secondBuilder = true end
    if secondBuilder then 
      display.writeLine("Demande de ".. builder, "justified", monitorMid)
    else 
      display.writeLine("Demande de ".. builder, "justified")
    end 
    for name, count in pairs(items) do
      if secondBuilder then 
        display.writeLine(name .. " : " ..count, "justified", monitorMid)
      else
        display.writeLine(name .. " : " ..count, "justified")
      end
    end
  end
end

      
  
