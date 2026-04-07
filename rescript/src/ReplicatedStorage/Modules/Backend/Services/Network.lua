local RunService = game:GetService("RunService")

local Network = {}
Network.EventListeners = {}
Network.FunctionListeners = {}

local event, func = script:FindFirstChild("Event"), script:FindFirstChild("Function")

local function routeEvent(v, ...)
	local args = { ... }
	local command = table.remove(args, 1)

	if not Network.EventListeners[command] then
		return
	end
	if RunService:IsServer() then
		Network.EventListeners[command](v, unpack(args))
	else
		Network.EventListeners[command](unpack(args))
	end
end

local function routeInvoke(v, ...)
	local args = { ... }
	local command = table.remove(args, 1)

	if not Network.FunctionListeners[command] then
		return
	end
	local result = table.pack(Network.FunctionListeners[command](v, unpack(args)))
	return result
end

function Network.__init()
	if not event or not func then
		error("network: missing RemoteEvent or RemoteFunction")
	end

	if RunService:IsServer() then
		event.OnServerEvent:Connect(routeEvent)
		func.OnServerInvoke = routeInvoke
	else
		event.OnClientEvent:Connect(routeEvent)
	end
end

function Network:OnEvent(name, callback)
	self.EventListeners[name] = callback
end

function Network:OnInvoke(name, callback)
	self.FunctionListeners[name] = callback
end

function Network:Fire(...)
	local args = { ... }

	if RunService:IsServer() then
		local player = args[1]

		if player == nil then
			event:FireAllClients(...)
		else
			event:FireClient(...)
		end
	else
		event:FireServer(...)
	end
end

function Network:Invoke(...)
	if not RunService:IsClient() then
		return
	end

	return func:InvokeServer(...)
end

return Network
