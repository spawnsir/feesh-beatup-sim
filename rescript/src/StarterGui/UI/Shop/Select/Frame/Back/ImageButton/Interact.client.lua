local b = script.Parent;
local event = game.ReplicatedStorage.Events.ShopEvent;

b.MouseButton1Click:Connect(function()
	event:Fire("CloseShop");
end)
