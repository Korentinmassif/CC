-- description des fonctions liées a l'affichage
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

display.writeLine = function(line, attribute)
	if attribute == nil then
		if display.monitor == nil then error("Set display before writing") end
		_, y = display.monitor.getCursorPos()
		display.monitor.write(line)
		display.monitor.setCursorPos(1, y+1)
	elseif attribute == "centered" then
		if display.monitor == nil then error("Set display before writing") end
		_, y = display.monitor.getCursorPos()
		x, _ = display.scale()
		textLen = #line
		noSpace = (x-textLen)%2
		display.monitor.write(string.rep(" ", noSpace) .. line)
		display.monitor.setCursorPos(1, y+1)
	end
end
-- descriptions des fonctions liées a MineColonies
colony = nil
colony = {}
colony.minecolony = nil

colony.setColony = function(colony)
	colony.minecolony = colony
end

colony.getName = function()
	return colony.minecolony.getName()
end
