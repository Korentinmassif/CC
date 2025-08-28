-- speaker_client_sync.lua
local speaker = peripheral.find("speaker")
local modemSide = "back"
rednet.open(modemSide)

local buffer = {}
local isStarted = false
local chunkInterval = 0.05 -- délai fixe entre chunks (en secondes)

print("Client prêt. En attente des données...")

local function playLoop()
    while #buffer > 0 do
        local chunk = table.remove(buffer, 1)
        speaker.playAudio(chunk)
        sleep(chunkInterval)
    end
    print("Lecture terminée.")
end

while true do
    local id, msg, proto = rednet.receive("music")

    if type(msg) == "table" and msg.cmd == "chunk" then
        buffer[msg.seq] = msg.data

    elseif msg == "start" then
        print("Signal de départ reçu.")
        -- Trie et rejoue les chunks en ordre
        local orderedBuffer = {}
        for i = 1, #buffer do
            table.insert(orderedBuffer, buffer[i])
        end
        buffer = orderedBuffer
        isStarted = true
        playLoop()
        break
    elseif msg == "stop" then
        print("Arrêt forcé.")
        break
    end
end
