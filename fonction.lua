-- description des fonction lié a l'affichage
display = nil
display = {}
display.monitor = nil

display.setMonitor = function(monitor)
	display.monitor = monitor
	display.monitor.clear()
end
display.writeLine = function(line)
	if display.monitor == nil then error("Set display before writing") end
	_, y = display.monitor.getCursorPos()
	display.monitor.write(line)
	display.monitor.setCursorPos(1, y+1)
end


