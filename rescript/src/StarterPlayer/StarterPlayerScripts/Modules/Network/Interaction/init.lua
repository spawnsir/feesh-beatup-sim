local NetworkService, MusicService =
	require(game.ReplicatedStorage.Modules.Backend.Network),
	require(game:GetService("Players").LocalPlayer.PlayerScripts.Modules.System.Music)

local Events = {}

function Events.__init()
	NetworkService:OnEvent("Death", function(...)
		Events:Death(...)
	end)
end

function Events:Death(model)
	task.spawn(function()
		MusicService:PlaySFX("Death", model.HumanoidRootPart)
	end)
end

return Events
