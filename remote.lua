-- tablet_remote.lua
local modemSide = "back"  -- adapte selon ta tablette
rednet.open(modemSide)

print("Télécommande : lancement de la musique")
rednet.broadcast("play", "music")
print("Commande envoyée. Tu peux fermer la tablette.")
