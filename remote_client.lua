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
    local id, msg, proto = rednet.receive("music")

    if type(msg) == "table" and msg.cmd == "chunk" then
        -- On vérifie bien que .data est une string
        if type(msg.data) == "string" then
            buffer[msg.seq] = msg.data
        else
            print("⚠ Chunk reçu invalide (pas une string)")
        end

    elseif msg == "start" then
        print("Signal de départ reçu.")
        -- Trie les chunks dans l'ordre
        local orderedBuffer = {}
        for i = 1, #buffer do
            if buffer[i] then
                table.insert(orderedBuffer, buffer[i])
            end
        end
        buffer = orderedBuffer
        playLoop()
        break

    elseif msg == "stop" then
        print("Arrêt forcé.")
        break

    else
        print("Message ignoré (type = " .. type(msg) .. ")")
    end
end
