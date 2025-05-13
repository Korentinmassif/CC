-- master.lua
local receivers = {3, 4, 5} -- Remplace par les IDs de tes récepteurs
rednet.open("back") -- Adapte selon le côté du modem

while true do
  local _, msg = rednet.receive()

  if msg.cmd == "play" then
    print("Lecture de : " .. msg.url)
    local handle = http.get(msg.url, nil, true)
    if not handle then
      print("Erreur lors de l'accès à l'URL.")
    else
      local bufferChunks = {}

      -- Buffer initial (20 chunks ~ 1 seconde)
      for i = 1, 20 do
        local chunk = handle.read(1024)
        if not chunk then break end
        table.insert(bufferChunks, chunk)
        for _, id in ipairs(receivers) do
          rednet.send(id, { cmd = "chunk", data = chunk })
        end
      end

      -- Signal de démarrage synchronisé
      local startTick = os.epoch("utc") + 3000 -- dans 3 secondes
      for _, id in ipairs(receivers) do
        rednet.send(id, { cmd = "start_at_tick", tick = startTick })
      end

      -- Streaming continu
      while true do
        local chunk = handle.read(1024)
        if not chunk then break end
        for _, id in ipairs(receivers) do
          rednet.send(id, { cmd = "chunk", data = chunk })
        end
        os.sleep(0.05)
      end

      handle.close()
    end

  elseif msg.cmd == "stop" then
    print("Arrêt demandé.")
    for _, id in ipairs(receivers) do
      rednet.send(id, { cmd = "stop" })
    end
  end
end
