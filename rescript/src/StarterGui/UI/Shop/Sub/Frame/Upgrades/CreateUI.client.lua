local upgrades = {};

local remoteFunction = game.ReplicatedStorage.Functions.ShopFunction;
local event = game.ReplicatedStorage.Events:WaitForChild("ShopEvent");

upgrades = remoteFunction:InvokeServer("GetUpgrades");
print(upgrades)

local i = 0;
for j, v in pairs(upgrades) do
	local clone = script.Parent.Template:Clone();
	clone.Name = j;
	clone.Parent = script.Parent;
	
	if clone.Frame then 
		clone.Frame.Visible = false;
		clone.Frame.LayoutOrder = i;
	end
	
	i += 1;
end
	
task.wait()

for i, v in pairs(upgrades) do
	local amount = remoteFunction:InvokeServer("GetUpgradeAmount", i);
	game.ReplicatedStorage.Events.ShopEvent:Fire("CreateShop", upgrades, amount);
end
event:Fire("Shop", upgrades);


