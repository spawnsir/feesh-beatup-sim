local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local NetworkService, PlayerService

local InputEvents = {}

InputEvents.Events = {
	Input = function(player, input)
		player = PlayerService.GetPlayer(player.UserId)
		if not player then
			return
		end

		player.State:SetState(input, player)
	end,
}

function InputEvents.__init()
	NetworkService, PlayerService = ModuleHandler:Get("Network"), ModuleHandler:Get("PlayerService")
end

function InputEvents.__start()
	for eventName, callback in pairs(InputEvents.Events) do
		NetworkService:OnEvent(eventName, callback)
	end
end

return InputEvents
