local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local NetworkService, VFXService, MusicService

local CharacterEvents = {}

CharacterEvents.Events = {
	Smack = function(model)
		VFXService.HighlightModel(
			model,
			TweenInfo.new(2.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0)
		)

		task.spawn(function()
			MusicService:PlaySFX("Smack", model.HumanoidRootPart, true)
		end)
	end,

	PlaySFX = function(sfx, part, clone: boolean?, random: boolean?)
		task.spawn(function()
			MusicService:PlaySFX(sfx, part, clone, random)
		end)
	end,
}

function CharacterEvents.__init()
	NetworkService, VFXService, MusicService =
		ModuleHandler:Get("Network"), ModuleHandler:Get("VFX"), ModuleHandler:Get("Music")
end

function CharacterEvents.__start()
	for eventName, callback in pairs(CharacterEvents.Events) do
		NetworkService:OnEvent(eventName, callback)
	end
end

return CharacterEvents
