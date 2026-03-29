local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local NetworkService, VFXService, MusicService

local NPCEvents = {}

function NPCEvents.__init()
	NetworkService, VFXService, MusicService =
		ModuleHandler:Get("Network"), ModuleHandler:Get("VFX"), ModuleHandler:Get("Music")
end

function NPCEvents.__start()
	NetworkService:OnEvent("SmackedNPC", function(...)
		NPCEvents:OnHit(...)
	end)
end

function NPCEvents:OnHit(model)
	VFXService.HighlightModel(
		model,
		TweenInfo.new(2.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0)
	)

	task.spawn(function()
		MusicService:PlaySFX("Smack", model.HumanoidRootPart)
	end)
end

return NPCEvents
