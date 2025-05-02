local dfpwm = require("cc.audio.dfpwm")
local speaker = peripheral.find("speaker")
local decoder = dfpwm.make_decoder()

-- === CONFIGURATION ===
local folder = "." -- Remplace par "chunks_a" ou "chunks_b" si tes fichiers sont dans un sous-dossier

-- === LISTE ET TRI DES FICHIERS ===
local files = fs.list(folder)
local playlist = {}

for _, file in ipairs(files) do
  if file:match("%.dfpwm$") then
    table.insert(playlist, file)
  end
end

table.sort(playlist) -- Trie alphabétiquement (important pour l'ordre !)

-- === LECTURE DE CHAQUE FICHIER ===
for _, filename in ipairs(playlist) do
  local fullPath = fs.combine(folder, filename)
  local file = fs.open(fullPath, "rb")
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
    print("⚠️ Impossible d'ouvrir :", filename)
  end
end

print("✅ Lecture terminée.")
