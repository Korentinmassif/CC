-- broadcaster.lua
local protocol = "music"
local modemSide = "top"
rednet.open(modemSide)

local dfpwm = require("cc.audio.dfpwm")

-- Detect all attached speakers
local speakers = {}
for _, name in ipairs(peripheral.getNames()) do
  if peripheral.getType(name) == "speaker" then
    table.insert(speakers, peripheral.wrap(name))
  end
end

if #speakers == 0 then
  error("No speakers found.")
end

print("Speakers found: " .. #speakers)
print("Listening for music commands...")

-- Playback state
local playing = false
local stopSignal = false

-- Function to stream and play DFPWM
local function playSong(songName)
  local baseUrl = "https://github.com/Korentinmassif/CC/raw/refs/heads/main/"
  local url = baseUrl .. songName .. ".dfpwm"

  print("Fetching: " .. url)

  local response = http.get(url)
  if not response then
    print("Failed to fetch '" .. songName .. "' from GitHub.")
    return
  end

  local decoder = dfpwm.make_decoder()
  playing = true
  stopSignal = false

  while true do
    if stopSignal then
      print("Playback stopped.")
      break
    end

    local chunk = response.read(16)
    if not chunk then
      print("Playback finished.")
      break
    end

    local audio = decoder(chunk)
    for _, speaker in ipairs(speakers) do
      speaker.playAudio(audio)
    end
    os.sleep(0.05)
  end

  response.close()
  playing = false
end

-- Main command loop
while true do
  local _, msg, proto = rednet.receive(protocol)

  if msg == "stop" then
    if playing then
      stopSignal = true
    else
      print("Nothing is playing.")
    end
  else
    if playing then
      print("Already playing something. Please stop it first.")
    else
      parallel.waitForAny(
        function() playSong(msg) end,
        function()
          while playing do os.sleep(0.1) end
        end
      )
    end
  end
end
