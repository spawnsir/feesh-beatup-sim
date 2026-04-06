local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local NetworkService, PlayerService, AbilitySystem

local InputHandler = {}
InputHandler.Callbacks = {
	Dash = function() end,
}

local function _ability(input)
	local player = PlayerService.GetPlayer(game.Players.LocalPlayer.UserId)
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
	InputHandler:BindInputs()
end

function InputHandler:BindInputs()
	for _, input in pairs(game:GetService("ReplicatedStorage").Keybinds:GetChildren()) do
		if not input:IsA("InputAction") then
			continue
		end

		input.Pressed:Connect(function()
			NetworkService:Fire("Input", input.Name)

			task.spawn(function()
				_ability(input.Name)
				InputHandler.Callbacks[input.Name]()
			end)
		end)
	end
end

return InputHandler
