-- speaker_client_sync.lua
local speaker = peripheral.find("speaker")
local modemSide = "back"
rednet.open(modemSide)

local buffer = {}
local chunkInterval = 0.05

print("Client prêt. En attente des données...")

local function playLoop()
    for i = 1, #buffer do
        local chunk = buffer[i]
        if type(chunk) == "string" then
            speaker.playAudio(chunk)
            sleep(chunkInterval)
        else
            print("⚠ Chunk invalide au rang " .. tostring(i))
        end
    end
    print("Lecture terminée.")
end

while true do
    local id, msg, proto = rednet
