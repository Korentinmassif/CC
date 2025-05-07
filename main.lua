dofile(shell.resolve("fonction.lua"))
monitorMid = 39.5
monitor = peripheral.wrap("right")
minecolony = peripheral.wrap("left")

display.setMonitor(monitor)
colony.setColony(minecolony)

display.writeLine(colony.getName(), "centered", )
while true do
  req = colony.getBuilderJob()
  for builder, items in pairs(req) do
    display
  
