local NetworkService, VFXService, MusicService = 
	require(game.ReplicatedStorage.Modules.Backend.Network), 
	require(game:GetService("Players").LocalPlayer.PlayerScripts.Modules.System.VFX),
	require(game:GetService("Players").LocalPlayer.PlayerScripts.Modules.System.Music);

local NPCEvents = {}

function NPCEvents:OnHit(model)
	
	VFXService.HighlightModel(
		model, 
		TweenInfo.new(2.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0)
	);
	
	task.spawn(function()
		MusicService:PlaySFX("Smack", model.HumanoidRootPart);
	end)
	
end

NetworkService:OnEvent("SmackedNPC", function(...)
	NPCEvents:OnHit(...);
end)

return NPCEvents
