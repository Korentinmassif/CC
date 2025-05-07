display = {}
display.monitor = nil
display.writeLine = function (line)
	if display.monitor == nil then error("Set display before writing") end
	_, y = display.monitor.getCursorPos()
	display.monitor.write(line)
	display.monitor.setCursorPos(1, y+1)
end