local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local PlayerService = {}

local PlayerServiceShared

function PlayerService.__init()
	PlayerServiceShared = ModuleHandler:Get("PlayerService")
end

function PlayerService.__start()
	local player = game.Players.LocalPlayer
	if player then
		PlayerServiceShared.SetupPlayer(player)
	end
end

return PlayerService
