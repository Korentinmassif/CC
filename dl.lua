-- Télécharge et enregistre le fichier butterfly.dfpwm localement
local url = "https://github.com/Korentinmassif/CC/raw/refs/heads/main/butterfly.dfpwm"
local response = http.get(url)

if response then
    local file = fs.open("butterfly.dfpwm", "wb")
    file.write(response.readAll())
    file.close()
    response.close()
    print("Téléchargement terminé.")
else
    print("Échec du téléchargement.")
end
