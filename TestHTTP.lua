local url = "https://raw.githubusercontent.com/Korentinmassif/CC/refs/heads/main/CIEL.dfpwm"
local response = http.get(url)

if response then
    local file = fs.open("CIEL.dfpwm", "wb")
    file.write(response.readAll())
    file.close()
    print("Fichier téléchargé avec succès.")
else
    print("Erreur lors du téléchargement.")
end
