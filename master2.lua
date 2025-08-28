local http = require("http")
local rednet = require("rednet")
rednet.open("right") -- adapte à ta config modem

local url = "https://raw.githubusercontent.com/tonPseudo/tonRepo/main/musique.dfpwm" -- remplace par ton URL raw

print("Téléchargement du fichier DFPWM depuis GitHub...")
local resp = http.get(url)
if not resp then
  print("Erreur : impossible de télécharger le fichier")
  return
end
local data = resp.readAll()
resp.close()
print("Fichier téléchargé, taille :", #data, "octets")

local chunkSize = 200
local chunks = {}
for i = 1, #data, chunkSize do
  table.insert(chunks, data:sub(i, i + chunkSize - 1))
end
print("Fichier découpé en", #chunks, "chunks")

-- Découverte clients
local clients = {}
print("En attente des clients (5 sec)...")
local timer = os.startTimer(5)
while true do
  local e, p1, p2 = os.pullEvent()
  if e == "rednet_message" then
    local sender, message = p1, p2
    if message.cmd == "register" then
      clients[sender] = {offset = 0, ready = false}
      print("Client enregistré :", sender)
    end
  elseif e == "timer" and p1 == timer then
    break
  end
end

if next(clients) == nil then
  print("Aucun client détecté, arrêt.")
  return
end

-- Fonction pour envoyer les chunks à un client, chunk par chunk, avec attente de confirmation
local function sendChunksToClient(clientId)
  print("Envoi des chunks à", clientId)
  for i, chunk in ipairs(chunks) do
    local tries = 0
    while tries < 5 do -- 5 essais max par chunk
      rednet.send(clientId, {cmd = "chunk", index = i, data = chunk})
      -- Attendre confirmation chunk reçue
      local sender, message = rednet.receive(2)
      if sender == clientId and message.cmd == "ack" and message.index == i then
        break -- chunk reçu, passer au suivant
      else
        tries = tries + 1
        print("Réenvoi chunk", i, "à", clientId, "(essai", tries, ")")
      end
    end
    if tries == 5 then
      print("Erreur : chunk", i, "non reçu par", clientId)
      return false
    end
  end
  -- Envoyer message ready
  rednet.send(clientId, {cmd = "ready", totalSize = #data})
  -- Attendre confirmation ready
  local sender, message = rednet.receive(5)
  if sender == clientId and message.cmd == "ready_ack" then
    print("Client", clientId, "prêt.")
    clients[clientId].ready = true
    return true
  else
    print("Erreur : client", clientId, "n'a pas confirmé ready")
    return false
  end
end

-- Envoyer les chunks à tous les clients
for clientId,_ in pairs(clients) do
  local success = sendChunksToClient(clientId)
  if not success then
    print("Abandon du transfert pour client", clientId)
    clients[clientId].ready = false
  end
end

-- Attendre que tous les clients soient prêts
local allReady = false
local timeout = os.startTimer(15)
while not allReady do
  allReady = true
  for _, info in pairs(clients) do
    if not info.ready then
      allReady = false
      break
    end
  end
  if allReady then break end
  local event, param1 = os.pullEvent()
  if event == "timer" and param1 == timeout then
    print("Timeout d'attente des clients prêts")
    break
  end
end

-- Fonction synchronisation ping-pong
local function syncClient(id)
  local sendTime = os.clock()
  rednet.send(id, {cmd = "ping", time = sendTime})
  local senderId, message = rednet.receive(2)
  if senderId == id and message.cmd == "pong" and message.time then
    local receiveTime = os.clock()
    local clientTime = message.time
    local latency = (receiveTime - sendTime) / 2
    local offset = (sendTime + latency) - clientTime
    return offset
  else
    return nil
  end
end

-- Synchroniser les clients prêts
print("Synchronisation des clients...")
for clientId, info in pairs(clients) do
  if info.ready then
    local offset = syncClient(clientId)
    if offset then
      clients[clientId].offset = offset
      print("Client", clientId, "offset:", offset)
    else
      print("Client", clientId, "non synchronisé")
    end
  end
end

-- Démarrage 10 secondes dans le futur
local startTimeMaster = os.clock() + 10
print("Démarrage prévu à :", startTimeMaster)

-- Envoyer signal start avec correction offset
for clientId, info in pairs(clients) do
  if info.ready then
    local correctedTime = startTimeMaster - info.offset
    rednet.send(clientId, {cmd = "start", time = correctedTime})
  end
end

print("Signal de démarrage envoyé à tous les clients prêts.")

-- Jouer la musique sur le maître aussi
local speaker = peripheral.find("speaker")
if not speaker then
  print("Warning: aucun speaker détecté sur le maître.")
else
  local delay = startTimeMaster - os.clock()
  if delay > 0 then sleep(delay) end
  print("Lecture musique sur le maître")
  speaker.playSound(data)
  print("Musique terminée sur le maître.")
end
