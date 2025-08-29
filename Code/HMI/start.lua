require"src/monitor"
require"src/state_machine"

state = machine.init
monitor = nil
window = nil


while true do
    if state == machine.init then 
        monitor = Monitor.new()
        monitor:clear()
        state = machine.start
    elseif state == machine.start then
        window = require"PIC/main_menu"
        monitor:loadConfig(window)
        monitor:draw()
    end
    os.sleep(0.1)
end

