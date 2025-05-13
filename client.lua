rednet.open("back")

while true do
    local senderID, message = rednet.receive()
    if message == "butterfly" then
        shell.run("speaker play https://github.com/Korentinmassif/CC/raw/refs/heads/main/butterfly.dfpwm")
    elseif message == "bailando" then
        shell.run("speaker play https://github.com/Korentinmassif/CC/raw/refs/heads/main/bailando.dfpwm")
    end
end
