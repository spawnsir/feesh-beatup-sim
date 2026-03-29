local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local ProfileStore, ServerService

local Data = {}
Data.AllowSaving = true
Data.Profile = {}
Data.Variables = {
	Cash = 0,
	Upgrades = {
		CashMultiplier = 0,
		Gravity = 25,
	},
}

local PlayerStore

local serverId, ownerId = game.PrivateServerId, game.PrivateServerOwnerId

if game:GetService("RunService"):IsStudio() then
	serverId, ownerId = "test", 718898024
end

function Data.__init()
	ProfileStore, ServerService = ModuleHandler:Get("ProfileStore"), ModuleHandler:Get("ServerService")
end

function Data.__start()
	PlayerStore = ProfileStore.New("PlayerStore", Data.Variables)
	if serverId == "" or not serverId or ownerId == 0 then
		warn("no private server, no data save")
		Data.AllowSaving = false
		return
	end

	-- Start a profile session for this player's data:

	Data.Profile = PlayerStore:StartSessionAsync(`{serverId}`, {})

	-- Handling new profile session or failure to start it:

	if Data.Profile ~= nil then
		Data.Profile:AddUserId(ownerId) -- GDPR compliance
		Data.Profile:Reconcile() -- Fill in missing variables from PROFILE_TEMPLATE (optional)

		Data.Profile.OnSessionEnd:Connect(function()
			ServerService.KickAllPlayers("profile session ended, please rejoin! :3")
		end)

		if Data.Profile.Data then
			for i, v in pairs(Data.Profile.Data) do
				Data:SetDataValue(i, v)
			end
		end
	else
		-- This condition should only happen when the Roblox server is shutting down
		ServerService.KickAllPlayers("profile failed to load, please rejoin! :3")
	end

	game:BindToClose(function()
		Data.Save() -- Save the profile data when the server shuts down
		Data.Profile:EndSession() -- End the profile session when the server shuts down
	end)
end

function Data.Save()
	if not Data.AllowSaving then
		return
	end
	for i, v in pairs(Data.Variables) do
		Data.Profile.Data[i] = v
	end

	if not Data.Profile:IsActive() then
		return
	end
	Data.Profile:Save()
end

function Data.Reset()
	Data.Profile:Reset()
end

function Data:SetDataValue(key, value)
	self.Variables[key] = value

	local object = game.ReplicatedStorage.Stats:FindFirstChild(key)
	if not object then
		return
	end
	object.Value = value
end

return Data
