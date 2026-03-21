local UserInputService = game:GetService("UserInputService");
local remote = game.ReplicatedStorage.Events.PlayerEvent;

local player = game.Players.LocalPlayer

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.R then
		remote:FireServer("Teleport");
	end
end)
