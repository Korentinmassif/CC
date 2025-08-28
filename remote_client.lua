-- speaker_client_sync.lua
local speaker = peripheral.find("speaker")
local modemSide = "back"
rednet.open(modemSide)

local buffer = {}
local chunkInterval = 0.05

print("Client prêt. En attente de données synchronisées...")

local function playLoop()
    for i = 1, #buffer do
        speaker.playAudio(buffer[i])
        sleep(chunkInterval)
    end
    print("Lecture terminée.")
end

while true do
    local _, msg, _ = rednet.receive("music")

    if type(msg) == "table" then
        if msg.cmd == "chunk" and type(msg.data) == "string" then
            buffer[msg.seq] = msg.data

        elseif msg.cmd == "start" then
            print("Signal de départ reçu.")
            -- Trie les chunks
            local ordered = {}
            for i = 1, #buffer do
                if buffer[i] then
                    table.insert(ordered, buffer[i])
                end
            end
            buffer = ordered
            playLoop()
            break

        elseif msg.cmd == "stop" then
            print("Arrêt reçu.")
            break
        else
            print("Message inconnu reçu : " .. tostring(msg.cmd))
        end
    else
        print("⚠ Message ignoré (pas une table)")
    end
end
