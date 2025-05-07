local colony = peripheral.wrap("back")
local buildRequest = {}

requests = colony.getRequests()

for _, request in ipairs(requests) do 
	if not request.satisfied then
		if request.requester.type == "builder" then -- la request vient d'un builder
			if buildRequest[request.requester.name] == nil then buildRequest[request.requester.name] = {} end
			buildRequest[request.requester.name][request.displayName] = request.count
		end
	end
end

for builder, request in pairs(buildRequest) do
	print("requette pour" .. builder .." : ")
	for requestIndex, item in ipairs(request) do
		for itemName, count in pairs(item) do
			print("\t"..requestIndex..".\t"..itemName.." : "..count)
		end
	end
end
