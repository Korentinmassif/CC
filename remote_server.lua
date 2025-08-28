-- streamer_server_sync_commanded.lua
local modemSide = "back"
local chunkSize = 4096
local delay = 0.05
local url = "https://raw.githubusercontent.com/Korentinmassif/CC/main/CIEL.dfpwm"
local preloadChunks = 5

rednet.open(modemSide)

print("Serveur prêt. En attente de la commande 'play' depuis la tablette...")

-- Attente de la commande "play"
while true do
    local id, msg, proto = rednet.receive("music")
    if msg == "play" then
        print("Commande reçue. Début du streaming.")
        break
    end
end

-- Connexion au fichier sur GitHub
local response = http.get(url, nil, true)
if not response then
    print("Erreur : impossible de se connecter à l'URL.")
    return
end

-- Streaming synchronisé
local seq = 1

-- Phase de préchargement
for i = 1, preloadChunks do
    local chunk = response.read(chunkSize)
    if not chunk then break end
    rednet.broadcast({
        cmd = "chunk",
        seq = seq,
        data = chunk
    }, "music")
    seq = seq + 1
    sleep(0) -- envoie rapide
end

-- Envoi du signal de départ
print("Préchargement terminé. Démarrage de la lecture.")
rednet.broadcast("start", "music")

-- Envoi du reste des chunks
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
rednet.broadcast("stop", "music")
print("Streaming terminé.")
