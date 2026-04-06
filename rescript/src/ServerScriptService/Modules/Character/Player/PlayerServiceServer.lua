local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local Players = game:GetService("Players")

local PlayerServiceShared

local PlayerService = {}

function PlayerService.__init()
	PlayerServiceShared = ModuleHandler:Get("PlayerService")
end

function PlayerService.__start()
	for _, player in pairs(Players:GetPlayers()) do
		PlayerServiceShared.SetupPlayer(player)
	end

	Players.PlayerAdded:Connect(function(player)
		PlayerServiceShared.SetupPlayer(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		PlayerServiceShared.AllPlayers[player] = nil
	end)
end

return PlayerService
