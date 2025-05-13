-- broadcaster.lua v0.12
local protocol = "music"
local modemSide = "back"
rednet.open(modemSide)

local dfpwm = require("cc.audio.dfpwm")

-- Find all speakers
local speakers = {}
for _, name in ipairs(peripheral.getNames()) do
  if peripheral.getType(name) == "speaker" then
    table.insert(speakers, peripheral.wrap(name))
  end
end

if #speakers == 0 then
  error("No speakers found.")
end

print("Speakers found:", #speakers)
print("Listening for music commands...")

local playing = false
local stopSignal = false
local buffer = {}
local bufferSize = 1024 * 4  -- Increase buffer size (8KB)
local bufferIndex = 1
local fetching = false

-- Function to preload song data into buffer
local function bufferSong(songName)
  local baseUrl = "https://github.com/Korentinmassif/CC/raw/refs/heads/main/"
  local url = baseUrl .. songName .. ".dfpwm"
  print("Starting stream:", url)

  local response = http.get(url)
  if not response then
    print("Failed to fetch:", songName)
    return false
  end

  while true do
    if #buffer >= bufferSize then
      print("Buffer full, stopping fetch.")
      break  -- Stop buffering when we have enough data
    end

    local chunk = response.read(512)  -- Increase chunk size for faster download
    if not chunk then
      print("No more data available.")
      break  -- End of stream
    end

    table.insert(buffer, chunk)
    print("Buffered", #buffer, "chunks.")
  end

  response.close()
  print("Buffer filled with", #buffer, "chunks.")
  return true
end

-- Function to play buffered song
local function playBufferedSong()
  local decoder = dfpwm.make_decoder()

  while true do
    if stopSignal then
      print("Playback stopped.")
      break
    end

    if bufferIndex > #buffer then
      print("Buffer empty, waiting for more data...")
      os.sleep(0.05)
    else
      -- Get the next chunk to play
      local chunk = buffer[bufferIndex]
      bufferIndex = bufferIndex + 1

      local audio = decoder(chunk)

      -- Play the audio on all speakers
      for _, speaker in ipairs(speakers) do
        speaker.playAudio(audio)
      end

      -- Sleep based on audio length (48,000 samples per second)
      local seconds = #audio / 48000
      os.sleep(seconds)
    end
  end
end

-- Function to fetch more data in the background
local function fetchData(songName)
  while true do
    if #buffer < bufferSize and not fetching then
      fetching = true
      print("Fetching more data...")
      local success = bufferSong(songName)
      fetching = false
      if not success then
        print("Error fetching data!")
        break
      end
    end
    os.sleep(0.05)  -- Shortened sleep to allow more frequent fetching
  end
end

-- Main loop
while true do
  local _, msg, proto = rednet.receive(protocol)

  if msg == "stop" then
    if playing then
      stopSignal = true  -- Stop playback
    else
      print("Nothing is playing.")
    end
  else
    if playing then
      print("Already playing. Please stop current song first.")
    else
      -- Start streaming and buffering in parallel
      playing = true
      bufferIndex = 1
      stopSignal = false

      -- Ensure that the buffer has enough data before starting
      local success = bufferSong(msg)
      if success then
        parallel.waitForAny(
          function() fetchData(msg) end,  -- Fetch data in parallel
          function() playBufferedSong() end  -- Start playback
        )
      else
        print("Failed to buffer song:", msg)
      end

      playing = false
    end
  end
end

