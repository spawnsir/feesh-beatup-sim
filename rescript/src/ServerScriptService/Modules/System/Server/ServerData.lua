local ProfileStore, ServerService =
	require(game.ServerScriptService.Packages.ProfileStore),
	require(game.ServerScriptService.Modules.System.Server.ServerService)

local ServerData = {}
ServerData.Profile = {}
ServerData.DATA_TEMPLATE = {
	cash = 0,
	upgrades = {},
}

local PlayerStore = ProfileStore.New("PlayerStore", ServerData.DATA_TEMPLATE)

local serverId, ownerId = game.PrivateServerId, game.PrivateServerOwnerId

if game:GetService("RunService"):IsStudio() then
	serverId, ownerId = 1, 718898024
end

function ServerData.__init()
	if serverId == "" or not serverId or ownerId == 0 then
		warn("no private server, no data save")
		return
	end

	-- Start a profile session for this player's data:

	ServerData.Profile = PlayerStore:StartSessionAsync(`{serverId}`, {})

	-- Handling new profile session or failure to start it:

	if ServerData.Profile ~= nil then
		ServerData.Profile:AddUserId(serverId) -- GDPR compliance
		ServerData.Profile:Reconcile() -- Fill in missing variables from PROFILE_TEMPLATE (optional)

		ServerData.Profile.OnSessionEnd:Connect(function()
			ServerService.KickAllPlayers("profile session ended, please rejoin! :3")
		end)
	else
		-- This condition should only happen when the Roblox server is shutting down
		ServerService.KickAllPlayers("profile failed to load, please rejoin! :3")
	end

	game:BindToClose(function()
		ServerData.Profile:EndSession()
	end)
end

return ServerData
