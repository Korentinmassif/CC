local rednet = require("rednet")
rednet.open("left") -- adapte selon ta config modem

local dfpwmBuffer = {}
local totalSize = nil

print("Enregistrement auprès du maître...")
rednet.broadcast({cmd = "register"})

local speaker = peripheral.find("speaker")
if not speaker then
  print("Erreur: aucun speaker détecté !")
end

while true do
  local senderId, message = rednet.receive()
  if message.cmd == "chunk" then
    -- Sauvegarder chunk
    dfpwmBuffer[message.index] = message.data
    -- Envoyer ack au maître
    rednet.send(senderId, {cmd = "ack", index = message.index})

  elseif message.cmd == "ready" then
    totalSize = message.totalSize
    print("Musique reçue, taille totale :", totalSize)
    rednet.send(senderId, {cmd = "ready_ack"})

  elseif message.cmd == "ping" then
    rednet.send(senderId, {cmd = "pong", time = os.clock()})

  elseif message.cmd == "start" and message.time then
    local fullData = table.concat(dfpwmBuffer)
    print("Lecture synchronisée à l'heure :", message.time)
    local delay = message.time - os.clock()
    if delay > 0 then sleep(delay) end

    if speaker then
      speaker.playSound(fullData)
      print("Lecture terminée.")
    else
      print("Pas de speaker détecté.")
    end
  end
end
