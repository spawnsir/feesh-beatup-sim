local remote = game.ReplicatedStorage.Events.PlayerEvent;

local player = game.Players.LocalPlayer

script.Parent.Activated:Connect(function()
	remote:FireServer("Teleport");

end)

