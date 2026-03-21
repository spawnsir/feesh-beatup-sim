local shop = require(script.Parent.Parent.System.Shop);

local remote = game.ReplicatedStorage.Events.ShopRemoteEvent;

game.ReplicatedStorage.Functions.ShopFunction.OnServerInvoke = function(player, event, value)
	if event == "GetUpgrades" then
		for i, v in pairs(shop.Upgrades) do
			if type(v) == "function" then continue end
			print(i);
			shop.Upgrades:CalculateCost(i);
		end
		return shop.Upgrades;
	end
	
	if event == "GetUpgradeAmount" then
		local upgrade = shop.Upgrades[value];
		return upgrade["Amount"].Value
	end
	
	return nil
end

remote.OnServerEvent:Connect(function(player, event, value)
	print(event)
	if event == "BuyUpgrade" then
		shop.Upgrades:BuyUpgrade(value);
	end
end)
