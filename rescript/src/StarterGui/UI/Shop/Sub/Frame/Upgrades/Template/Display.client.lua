local remote = game.ReplicatedStorage.Events.ShopRemoteEvent;
local event = game.ReplicatedStorage.Events.ShopEvent;

local connect = event.Event:Once(function(event, u, a)
	if event ~= "CreateShop" then return end
	
	local upgrade = u[script.Parent.Name];
	
	if not upgrade then return end
	
	for i, v in pairs(script.Parent.Frame:GetChildren()) do
		if v:IsA("TextLabel") then
			local text = upgrade[v.Name]
			
			if v.Name == "Name" then
				text = script.Parent.Name;
			end
			if v.Name == "Quote" then
				text = '"' .. text .. '"';
			end
			if v.Name == "Amount" then
				print(upgrade);
				text = "Currently owned: " ..a;
			end
			if v.Name == "Cost" then
				text = "Price: " .. upgrade["ActualCost"];
			end
			
			v.Text = text;
		end
		if v:IsA("ImageLabel") then
			v.Image = upgrade["Decal"];
		end
	end
end)

remote.OnClientEvent:Connect(function(player, event, upgrades, amount)
	print("updating shop");
	if event ~= "UpdateShop" or not upgrades then return end
	
	if not upgrades[script.Parent.Name] then return end
	
	for i, v in pairs(script.Parent.Frame:GetChildren()) do
		if not v:IsA("TextLabel") or v.Name ~= "Cost" and v.Name ~= "Amount" then continue end
		if v.Name == "Cost" then
			print(upgrades[script.Parent.Name]["ActualCost"])
			v.Text = "Price: " .. upgrades[script.Parent.Name]["ActualCost"];
		end
		
		if v.Name == "Amount" then
			print(amount[script.Parent.Name])
			v.Text = "Currently owned: " .. amount[script.Parent.Name];
		end
	end
end)

