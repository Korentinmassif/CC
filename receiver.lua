-- receiver.lua
local speaker = peripheral.find("speaker")
local dfpwm = require("cc.audio.dfpwm")
local decoder = dfpwm.make_decoder()

rednet.open("back") -- adapte si nécessaire

local buffer = {}
local isPlaying = false

-- Lecture fluide du buffer
local function audio_loop()
  while isPlaying do
    if #buffer > 0 then
      local frame = table.remove(buffer, 1)
      speaker.playAudio(frame)
    end
    sleep(0.05) -- lecture régulière (20 FPS = 1 chunk toutes les 50ms)
  end
end

-- Exécution principale
while true do
  local _, msg = rednet.receive()

  if msg.cmd == "chunk" then
    local ok, decoded = pcall(function()
      return decoder(msg.data)
    end)
    if ok and decoded then
      table.insert(buffer, decoded)
    end

  elseif msg.cmd == "start_at_tick" then
    local delay = msg.tick - os.epoch("utc")
    if delay > 0 then sleep(delay / 1000) end
    isPlaying = true
    audio_loop()

  elseif msg.cmd == "stop" then
    isPlaying = false
    buffer = {}
    speaker.stop()
  end
end
