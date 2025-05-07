-- description des fonction lié a l'affichage
display = nil
display = {}
display.monitor = nil

display.setMonitor = function(monitor)
	display.monitor = monitor
	display.monitor.clear()
	display.monitor.setCursorPos(1, 1)
end
display.scale = function(scale)
	if scale == nil then return display.monitor.getTextScale()
	else display.monitor.setTextScale(scale)
	end
end

display.writeLine = function(line)
	if display.monitor == nil then error("Set display before writing") end
	_, y = display.monitor.getCursorPos()
	display.monitor.write(line)
	display.monitor.setCursorPos(1, y+1)
end


