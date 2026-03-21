script.Parent.Transparency = 1;
local prompt = script.Parent.ProximityPrompt;

prompt.Triggered:Connect(function(player)
	if player.Character.Humanoid.Health <= 0 or player.Character.State.Value == "Dead" then return end
	game.ReplicatedStorage.Events.ShopRemoteEvent:FireClient(player, player, "OpenShop");
end)
