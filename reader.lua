local dfpwm = require("cc.audio.dfpwm")
local speaker = peripheral.find("speaker")
local decoder = dfpwm.make_decoder()

-- === CONFIGURATION ===
local folder = "music" -- Dossier où se trouvent tous les fichiers .dfpwm

-- === LISTE ET TRI DES FICHIERS ===
local files = fs.list(folder)
local playlist = {}

for _, file in ipairs(files) do
  if file:match("%.dfpwm$") then
    table.insert(playlist, file)
  end
end

-- Trie avec sensibilité au nombre ET aux lettres (ex: part1a < part2a < part10a < part1b)
table.sort(playlist, function(a, b)
  return a:lower() < b:lower()
end)

-- === LECTURE DE CHAQUE FICHIER ===
for _, filename in ipairs(playlist) do
  local path = fs.combine(folder, filename)
  local file = fs.open(path, "rb")
  if file then
    print("🎵 Lecture :", filename)
    while true do
      local chunk = file.read(16 * 1024)
      if not chunk then break end
      local decoded = decoder(chunk)
      while not speaker.playAudio(decoded) do
        os.pullEvent("speaker_audio_empty")
      end
    end
    file.close()
  else
    print("❌ Erreur : impossible de lire", filename)
  end
end

print("✅ Lecture complète terminée.")
