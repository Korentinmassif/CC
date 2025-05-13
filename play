local arg = {...}
local sound = arg[1]
rednet.open("back")

rednet.broadcast(sound)
print("Message de lecture envoyé à tous les clients !")

rednet.close("back")
