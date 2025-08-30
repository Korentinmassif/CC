rednet.open("top")
AE = peripheral.wrap("back")
channel = 81

while true do 
    data = {}
    CPUs = AE.getCraftingCPUs()
    for _, CPU in pairs(CPUs) do 
        cpu_data = {}
        cpu_data.busy = CPU.isBusy
        if CPU.isBusy then 
            cpu_data.itemName = CPU.CraftingJob.Storage.DisplayName
            cpu_data.completion = 100 * CPU.CraftingJob.Progess / CPU.CraftingJob.TotalItem
        else
            cpu_data.itemName = "None"
            cpu_data.completion = 0
        end
        data.insert(cpu_data)
    end

    message = textutils.serialize(data)
    rednet.send("*", message, channel)
    os.sleep(0.02)
end

