-- tablet_remote.lua
local modemSide = "back"
rednet.open(modemSide)

local msg = {
  cmd = "play"
}

rednet.broadcast(msg, "music")
print("Commande { cmd = 'play' } envoyée.")
