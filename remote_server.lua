-- streamer_server_sync_commanded.lua
local modemSide = "back"
local chunkSize = 4096
local delay = 0.05
local url = "https://raw.githubusercontent.com/Korentinmassif/CC/main/CIEL.dfpwm"
local preloadChunks = 5

rednet.open(modemSide)
print("Serveur prêt. En attente d'une commande { cmd = 'play' }...")

-- Attente du signal de démarrage
while true do
    local _, msg, _ = rednet.receive("music")
    if type(msg) == "table" and msg.cmd == "play" then
        print("Commande PLAY reçue.")
        break
    end
end

-- Lancement du streaming
local response = http.get(url, nil, true)
if not response then
    print("Erreur : impossible de se connecter au fichier.")
    return
end

local seq = 1

-- Préchargement
for i = 1, preloadChunks do
    local chunk = response.read(chunkSize)
    if not chunk then break end
    rednet.broadcast({ cmd = "chunk", seq = seq, data = chunk }, "music")
    seq = seq + 1
end

-- Signal de départ
rednet.broadcast({ cmd = "start" }, "music")

-- Streaming principal
while true do
    local chunk = response.read(chunkSize)
    if not chunk then break end

    rednet.broadcast({
        cmd = "chunk",
        seq = seq,
        data = chunk
    }, "music")

    seq = seq + 1
    sleep(delay)
end

response.close()
rednet.broadcast({ cmd = "stop" }, "music")
print("Fin du streaming.")
