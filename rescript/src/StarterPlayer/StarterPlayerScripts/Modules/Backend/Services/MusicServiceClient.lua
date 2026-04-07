local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local NetworkService, MusicServiceShared

local MusicServiceClient = {}

function MusicServiceClient.__init()
	NetworkService, MusicServiceShared = ModuleHandler:Get("Network"), ModuleHandler:Get("MusicService")
end

function MusicServiceClient.__start()
	NetworkService:OnEvent("PlaySFX", function(sfx, part, clone: boolean?, random: boolean?)
		task.spawn(function()
			MusicServiceShared:PlaySFX(sfx, part, clone, random)
		end)
	end)
end

return MusicServiceClient
