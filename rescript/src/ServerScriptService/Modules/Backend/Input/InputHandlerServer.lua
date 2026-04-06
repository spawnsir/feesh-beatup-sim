local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local NetworkService, PlayerService, AbilitySystem

local InputEvents = {}

local function _ability(player, input)
	player = PlayerService.GetPlayer(player.UserId)
	if not player or player:IsOnCooldown(input) or not AbilitySystem.CanUse(player.State.CurrentState, input) then
		return
	end

	task.spawn(function()
		player.State:SetState(input, player)
	end)
end

InputEvents.Events = {
	Input = _ability,
}

function InputEvents.__init()
	NetworkService, PlayerService, AbilitySystem =
		ModuleHandler:Get("Network"), ModuleHandler:Get("PlayerService"), ModuleHandler:Get("AbilitySystem")
end

function InputEvents.__start()
	for eventName, callback in pairs(InputEvents.Events) do
		NetworkService:OnEvent(eventName, callback)
	end
end

return InputEvents
