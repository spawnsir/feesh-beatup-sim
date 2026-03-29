local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local NetworkService, MusicService

local PlayerEvents = {}

function PlayerEvents.__init()
	NetworkService, MusicService = ModuleHandler:Get("Network"), ModuleHandler:Get("Music")
end

function PlayerEvents.__start()
	NetworkService:OnEvent("Death", function(...)
		PlayerEvents:Death(...)
	end)
end

function PlayerEvents:Death(model)
	task.spawn(function()
		MusicService:PlaySFX("Death", model.HumanoidRootPart)
	end)
end

return PlayerEvents
