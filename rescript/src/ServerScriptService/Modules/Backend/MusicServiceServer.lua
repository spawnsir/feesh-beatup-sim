local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local Players = game:GetService("Players")

local NetworkService

local MusicService = {}

function MusicService.__init()
	NetworkService = ModuleHandler:Get("Network")
end

function MusicService:PlaySFX(name, parent, clone, random, character)
	for _, player in pairs(Players:GetPlayers()) do
		if player.Character == character then
			continue
		end
		NetworkService:Fire(player, "PlaySFX", name, parent, clone, random)
	end
end

return MusicService
