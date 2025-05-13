-- broadcaster.lua
local modemSide = "back"
local speaker = peripheral.find("speaker")
local protocol = "music"

if not speaker then
  error("No speaker connected!")
end

local dfpwm = require("cc.audio.dfpwm")
local decoder = dfpwm.make_decoder()

rednet.open(modemSide)

print("Listening for music commands...")

-- Global flags
local playing = false
local stopSignal = false

-- Function to play a specific song by name
local function playSong(songName)
  local baseUrl = "https://raw.githubusercontent.com/YourUser/YourRepo/main/"
  local url = baseUrl .. songName .. ".dfpwm"

  local response = http.get(url)
  if not response then
    print("Could not fetch: " .. url)
    return
  end

  playing = true
  stopSignal = false
  decoder = dfpwm.make_decoder()
  print("Playing: " .. songName)

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
    speaker.playAudio(audio)
    os.sleep(0.05)
  end

  response.close()
  playing = false
end

-- Main loop
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
      print("Already playing something. Stop it first.")
    else
      -- Start song in a parallel task
      parallel.waitForAny(
        function() playSong(msg) end,
        function()
          while playing do os.sleep(0.1) end
        end
      )
    end
  end
end
