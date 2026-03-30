local ModuleHandler = require(game:GetService("ReplicatedStorage"):WaitForChild("ModuleHandler"))

local Players = game:GetService("Players")

local ServerService = {}
ServerService.OwnerJoined = nil

local Constants

local serverId, ownerId = game.PrivateServerId, game.PrivateServerOwnerId

function ServerService.__init()
	Constants = ModuleHandler:Get("Constants")
end

function ServerService.__start()
	ServerService.OwnerJoined = serverId == "" or not serverId or ownerId == 0

	Players.PlayerAdded:Connect(function(player)
		if player:GetRankInGroupAsync(Constants.GROUP_ID) < Constants.AUTHORISED_RANK then
			player:Kick("not authorised,,,, sorry!!")
		end

		if ServerService:IsServerOwner(player) then
			ServerService.OwnerJoined = true
		else
			if ServerService.OwnerJoined then
				return
			end
			player:Kick("server owner has not joined :c")
		end
	end)

	Players.PlayerRemoving:Connect(function(player)
		if not ServerService:IsServerOwner(player) then
			return
		end
		ServerService.KickAllPlayers("server owner left :c")
	end)
end

function ServerService:IsServerOwner(player)
	if player.UserId == ownerId then
		return true
	end

	return false
end

function ServerService.KickAllPlayers(message: string?)
	message = message or "coolswag"

	for _, player in pairs(Players:GetPlayers()) do
		player:Kick(message)
	end
end

return ServerService
