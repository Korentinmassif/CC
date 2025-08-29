require"src/monitor"
require"src/state_machine"

state = machine.init
monitor = nil
window = nil


while true do
    if state == machine.init then 
        monitor = Monitor.new()
        state = machine.start
    else if state == machine.start then
        window = require"PIC/main_menu.lua"
        monitor:loadConfig(window)
        monitor:draw()
    end
    os.wait(0.1)
end
