local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local NetworkService, VFXService, MusicServiceShared

local NPCServiceClient = {}

function NPCServiceClient.__init()
	NetworkService, VFXService, MusicServiceShared =
		ModuleHandler:Get("Network"), ModuleHandler:Get("VFXService"), ModuleHandler:Get("MusicService")
end

function NPCServiceClient.__start()
	NetworkService:OnEvent("Smack", function(model)
		VFXService.HighlightModel(
			model,
			TweenInfo.new(2.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0)
		)

		task.spawn(function()
			MusicServiceShared:PlaySFX("Smack", model.HumanoidRootPart, true)
		end)
	end)
end

return NPCServiceClient
