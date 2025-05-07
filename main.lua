dofile(shell.resolve("fonction.lua"))
monitorMid = 39.5
monitor = peripheral.wrap("right")
minecolony = peripheral.wrap("left")

display.setMonitor(monitor)
colony.setColony(minecolony)

while true do
  
