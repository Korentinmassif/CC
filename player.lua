rednet.open("back")

print("Enter song name (e.g. song1) or 'stop' to stop:")

while true do
  io.write("> ")
  local msg = read()

  if msg ~= "" then
    rednet.broadcast(msg, "music") -- You can target a specific ID if you want
    print("Sent: " .. msg)
  end
end
