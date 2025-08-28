-- speaker_client_sync.lua
local speaker = peripheral.find("speaker")
local modemSide = "back" -- adapte selon ta config
rednet.open(modemSide)

local buffer = {}
local chunkInterval = 0.05 -- délai entre chaque chunk

print("Client prêt. En attente des données synchronisées...")

local function playLoop()
    for i = 1, #buffer do
        local chunk = buffer[i]
        if type(chunk) == "string" then
            speaker.playAudio(chunk)
            sleep(chunkInterval)
        else
            print("⚠ Chunk invalide à l'index " .. tostring(i))
        end
    end
    print("Lecture terminée.")
end

while true do
    local id, msg, proto = rednet.receive("music")

    if type(msg) == "table" and msg.cmd == "chunk" then
        if type(msg.seq) == "number" and type(msg.data) == "string" then
            buffer[msg.seq] = msg.data
        else
            print("⚠ Chunk reçu invalide (seq ou data manquant/invalide)")
        end

    elseif type(msg) == "table" and msg.cmd == "start" then
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

    elseif type(msg) == "table" and msg.cmd == "stop" then
        print("Arrêt forcé reçu.")
        break

    else
        print("Message ignoré ou non conforme reçu : " .. (msg.cmd or tostring(msg)))
    end
end
