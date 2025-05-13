local url = "https://github.com/Korentinmassif/CC/raw/refs/heads/main/Dana.dfpwm"
local speaker = peripheral.find("speaker")
local dfpwm = require("cc.audio.dfpwm")
local decoder = dfpwm.make_decoder()

local res = http.get(url)
if not res then error("Failed to fetch") end

while true do
  local chunk = res.read(16)
  if not chunk then break end
  local audio = decoder(chunk)
  speaker.playAudio(audio)
  os.sleep(0.05)
end

res.close()
