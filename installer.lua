-- installer.lua
local baseURL = "https://raw.githubusercontent.com/Korentinmassif/CC/main/"

local files = {
  ["pocket"] = "pocket.lua",
  ["master"] = "master.lua",
  ["receiver"] = "receiver.lua"
}

term.clear()
term.setCursorPos(1, 1)
print("=== Installateur Audio ===")
print("Sélectionnez le type de machine à installer :")
print("1. Pocket Controller")
print("2. Master Node")
print("3. Receiver Node")
local choix = read()

local cible
if choix == "1" then
  cible = "pocket"
elseif choix == "2" then
  cible = "master"
elseif choix == "3" then
  cible = "receiver"
else
  print("Choix invalide.")
  return
end

local nomFichier = "startup.lua"
local url = baseURL .. files[cible]

print("Téléchargement de " .. files[cible] .. "...")
local response = http.get(url)
if response then
  local content = response.readAll()
  response.close()

  local file = fs.open(nomFichier, "w")
  file.write(content)
  file.close()

  print("Installation terminée !")
  print("Redémarrage conseillé.")
else
  print("Erreur lors du téléchargement depuis :")
  print(url)
end
