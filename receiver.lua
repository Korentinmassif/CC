-- receiver.lua
local speaker = peripheral.find("speaker")
local audio = require("cc.audio")
local decoder = audio.make_decoder()

rednet.open("back") -- Adapte selon le côté du modem

local buffer = {}
local isPlaying = false

-- Lecture synchronisée
local function play_buffer()
  while isPlaying and #buffer > 0 do
    local frame = table.remove(buffer, 1)
    speaker.playAudio(frame)
    sleep(0.05) -- 20 FPS
  end
end

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
    play_buffer()

  elseif msg.cmd == "stop" then
    isPlaying = false
    buffer = {}
    speaker.stop()
  end
end
