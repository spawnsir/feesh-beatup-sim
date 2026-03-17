local b = script.Parent;

b.Activated:Connect(function()
	local upgrade = b.Parent.Parent.Parent.Name;
	
	game.ReplicatedStorage.Events.ShopRemoteEvent:FireServer("BuyUpgrade", upgrade);
end)
