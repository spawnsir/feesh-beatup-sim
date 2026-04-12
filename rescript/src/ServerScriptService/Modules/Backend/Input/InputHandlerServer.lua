local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local NetworkService, PlayerService, AbilitySystem

local InputHandler = {}
InputHandler.Callbacks = {
	Dash = function() end,
}

local function _ability(player, input)
	player = PlayerService.GetPlayer(player.Character)
	if not player or player:IsOnCooldown(input) or not AbilitySystem.CanUse(player.State.CurrentState, input) then
		return
	end

	task.spawn(function()
		player.State:SetState(input, player)
	end)
end

function InputHandler.__init()
	NetworkService, PlayerService, AbilitySystem =
		ModuleHandler:Get("Network"), ModuleHandler:Get("PlayerService"), ModuleHandler:Get("AbilitySystem")
end

function InputHandler.__start()
	NetworkService:OnEvent("Input", function(...)
		_ability(...)

		local callback = InputHandler.Callbacks[select(2, ...)]
		if not callback then
			return
		end
		callback()
	end)
end

return InputHandler
