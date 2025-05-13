rednet.open("back")

-- Fonction utilitaire pour jouer un son dans un thread séparé
local function playURL(url)
    parallel.waitForAny(
        function()
            shell.run("speaker play " .. url)
        end,
        function()
            -- thread vide juste pour que parallel ne bloque pas
        end
    )
end

local function playerStop()
    parallel.waitForAny(
        function()
            shell.run("speaker stop")
        end,
        function()
            -- thread vide juste pour que parallel ne bloque pas
        end
    )
end

while true do
    local senderID, message = rednet.receive()
    
    if message == "butterfly" then
        playURL("https://github.com/Korentinmassif/CC/raw/refs/heads/main/butterfly.dfpwm")
    elseif message == "bailando" then
        playURL("https://github.com/Korentinmassif/CC/raw/refs/heads/main/bailando.dfpwm")
    elseif message == "stop" then
        playerStop()
    end

end
