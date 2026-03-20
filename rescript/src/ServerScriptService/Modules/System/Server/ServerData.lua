local ProfileStore, ServerService =
	require(game.ServerScriptService.Packages.ProfileStore),
	require(game.ServerScriptService.Modules.System.Server.ServerService)

local ServerData = {}
ServerData.NoSave = false
ServerData.Profile = {}
ServerData.Data = {
	Cash = 0,
	Upgrades = {
		CashMultiplier = 0,
		Gravity = 25,
	},
}

local PlayerStore = ProfileStore.New("PlayerStore", ServerData.Data)

local serverId, ownerId = game.PrivateServerId, game.PrivateServerOwnerId

if game:GetService("RunService"):IsStudio() then
	serverId, ownerId = 1, 718898024
end

function ServerData.__init()
	if serverId == "" or not serverId or ownerId == 0 then
		warn("no private server, no data save")
		ServerData.NoSave = true
		return
	end

	-- Start a profile session for this player's data:

	ServerData.Profile = PlayerStore:StartSessionAsync(`{serverId}`, {})

	-- Handling new profile session or failure to start it:

	if ServerData.Profile ~= nil then
		ServerData.Profile:AddUserId(ownerId) -- GDPR compliance
		ServerData.Profile:Reconcile() -- Fill in missing variables from PROFILE_TEMPLATE (optional)

		ServerData.Profile.OnSessionEnd:Connect(function()
			ServerService.KickAllPlayers("profile session ended, please rejoin! :3")
		end)

		if ServerData.Profile.Data then
			for i, v in pairs(ServerData.Profile.Data) do
				ServerData:SetDataValue(i, v)
			end
		end
	else
		-- This condition should only happen when the Roblox server is shutting down
		ServerService.KickAllPlayers("profile failed to load, please rejoin! :3")
	end

	game:BindToClose(function()
		ServerData.Save() -- Save the profile data when the server shuts down
		ServerData.Profile:EndSession() -- End the profile session when the server shuts down
	end)
end

function ServerData.Save()
	if ServerData.NoSave then
		return
	end
	for i, v in pairs(ServerData.Data) do
		ServerData.Profile.Data[i] = v
	end

	if not ServerData.Profile:IsActive() then
		return
	end
	ServerData.Profile:Save()
end

function ServerData.Reset()
	ServerData.Profile:Reset()
end

function ServerData:SetDataValue(key, value)
	self.Data[key] = value

	local object = game.ReplicatedStorage.Stats:FindFirstChild(key)
	if not object then
		return
	end
	object.Value = value
end

return ServerData
