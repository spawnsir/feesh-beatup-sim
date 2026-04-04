local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local NetworkService, VFXService, MusicService

local NPCEvents = {}

NPCEvents.Events = {
	SmackedNPC = function(model)
		VFXService.HighlightModel(
			model,
			TweenInfo.new(2.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0)
		)

		task.spawn(function()
			MusicService:PlaySFX("Smack", model.HumanoidRootPart)
		end)
	end,
}

function NPCEvents.__init()
	NetworkService, VFXService, MusicService =
		ModuleHandler:Get("Network"), ModuleHandler:Get("VFX"), ModuleHandler:Get("Music")
end

function NPCEvents.__start()
	for eventName, callback in pairs(NPCEvents.Events) do
		NetworkService:OnEvent(eventName, callback)
	end
end

return NPCEvents
