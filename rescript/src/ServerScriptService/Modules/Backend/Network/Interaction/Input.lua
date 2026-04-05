local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local NetworkService, PlayerService, AbilitySystem

local InputEvents = {}

InputEvents.Events = {
	Input = function(player, input)
		player = PlayerService.GetPlayer(player.UserId)
		if not player then
			return false
		end

		if player:IsOnCooldown(input) or not AbilitySystem.CanUse(player.State.CurrentState, input) then
			return false
		end

		player.State:SetState(input, player)

		return true, AbilitySystem:GetAbility(input).SFX, player.Character.HumanoidRootPart, false
	end,
}

function InputEvents.__init()
	NetworkService, PlayerService, AbilitySystem =
		ModuleHandler:Get("Network"), ModuleHandler:Get("PlayerService"), ModuleHandler:Get("AbilitySystem")
end

function InputEvents.__start()
	for eventName, callback in pairs(InputEvents.Events) do
		NetworkService:OnInvoke(eventName, callback)
	end
end

return InputEvents
