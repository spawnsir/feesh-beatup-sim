local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local NetworkService, MusicService

local PlayerEvents = {}

PlayerEvents.Events = {
	Death = function(model)
		task.spawn(function()
			MusicService:PlaySFX("Death", model.HumanoidRootPart)
		end)
	end,
}

function PlayerEvents.__init()
	NetworkService, MusicService = ModuleHandler:Get("Network"), ModuleHandler:Get("Music")
end

function PlayerEvents.__start()
	for eventName, callback in pairs(PlayerEvents.Events) do
		NetworkService:OnEvent(eventName, callback)
	end
end

return PlayerEvents
