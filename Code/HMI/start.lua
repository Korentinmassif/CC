require"src/monitor"
require"src/state_machine"

state = machine.init
monitor = nil
window = nil
future_config = "PIC/main_menu"


while true do
    if state == machine.init then 
        monitor = Monitor.new()
        monitor:clear()
        state = machine.load
    elseif state == machine.wait_click then
        local event, side, x, y = os.pullEvent("monitor_touch")
        local button = monitor:getButtonAt(x, y)
        if button and button.onClick then
            future_config = button.onClick()
        end
        if future_config == "Quit" then 
            state = machine.quit
        elseif future_config then
            state = machine.empty_cache
        end
    elseif state == machine.empty_cache then 
        monitor:flush()
        state = machine.load
    elseif state == machine.load then 
        window = require(future_config)
        future_config = nil
        monitor:loadConfig(window)
        monitor:draw()
        state = machine.wait_click
    end
    os.sleep(0.05)
end

