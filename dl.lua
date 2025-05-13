local url = "https://github.com/Korentinmassif/CC/raw/refs/heads/main/butterfly.dfpwm"
local response = http.get(url)

if not response then
    print("Échec du téléchargement.")
    return
end

local file = fs.open("butterfly.dfpwm", "wb")

while true do
    local chunk = response.read(1024)
    if not chunk then break end
    file.write(chunk)
end

file.close()
response.close()

print("Téléchargement terminé sans surcharge mémoire.")

