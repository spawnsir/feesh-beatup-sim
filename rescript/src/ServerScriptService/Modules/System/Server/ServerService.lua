local Players = game:GetService("Players")

local ServerService = {}
ServerService.OwnerJoined = nil

local serverId, ownerId = game.PrivateServerId, game.PrivateServerOwnerId
local GROUP_ID = 109654349 -- Replace with your group ID
local RANK_TO_KICK = 253 -- Replace with the rank that should be kicked

function ServerService.__init()
	ServerService.OwnerJoined = serverId == "" or not serverId or ownerId == 0
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

Players.PlayerAdded:Connect(function(player)
	if not player:IsInGroupAsync(GROUP_ID) or player:GetRankInGroupAsync(GROUP_ID) <= RANK_TO_KICK then
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

return ServerService
