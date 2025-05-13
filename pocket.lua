-- pocket.lua
local masterId = 1 -- Remplace par l'ID de ton Master Node
rednet.open("back") -- Adapte selon le côté du modem

while true do
  term.clear()
  term.setCursorPos(1, 1)
  print("=== Contrôleur Audio ===")
  print("1. Jouer une musique")
  print("2. Arrêter la musique")
  local choix = read()

  if choix == "1" then
    print("Entrez le nom du fichier DFPWM :")
    local url = read()
    rednet.send(masterId, { cmd = "play", url = "https://github.com/Korentinmassif/CC/raw/refs/heads/main/".. url .. ".dfpwm" })
  elseif choix == "2" then
    rednet.send(masterId, { cmd = "stop" })
  end
end
