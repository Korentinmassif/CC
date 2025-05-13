local protocol = "music"
rednet.open("back")

print("Enter a song name (e.g. 'intro') or type 'stop':")

while true do
  io.write("> ")
  local input = read()
  if input and input ~= "" then
    rednet.broadcast(input, protocol)
    print("Sent: " .. input)
  end
end

