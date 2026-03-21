local stats = require(game.ServerScriptService.System.StatsManager);
local remote = game.ReplicatedStorage.Events.ShopRemoteEvent;

local shop = {}

shop.Upgrades = {
	Strength = {
		Name = "Genflux",
		ActualCost = 10,
		CostFormula = function(x:number) return 10 + (15 * x ^ 1.5); end,
		Desc = "Found this thang in the back alley, sure seems to help make hits pack more of a punch.",
		Quote = "Warning: Side effects may include nausea, headaches, bad odor and may cause the user to become a goose.",
		Decal = "rbxassetid://94442753544486",
		Amount = Instance.new("IntValue")
	}
}

for i, v in pairs(shop.Upgrades) do
	if type(v) == "function" then continue end
	v["Amount"].Changed:Connect(function()
		shop.Upgrades:CalculateCost(i);
		shop.Upgrades:UpdateShop();
	end)
end

function shop.Upgrades:GetUpgrades()
	for _, v in pairs(shop.Upgrades) do
		local stat:number = stats:GetStat("Upgrades")[v];
		
		if stat then
			v["Amount"].Value = stat;
		end
	end
end

function shop.Upgrades:BuyUpgrade(upgrade:string)
	local u = shop.Upgrades[upgrade];
	
	if not u or stats:GetStat("Money") < u["ActualCost"] then return end
	stats:IncrementStat("Money", -u["ActualCost"]);
	stats:SetStat("Upgrades", {upgrade, u["Amount"].Value + 1});
	
	u["Amount"].Value = stats:GetStat("Upgrades")[upgrade];
end

function shop.Upgrades:UpdateShop()
	local amount = {}
	for i, v in pairs(shop.Upgrades) do
		if type(v) == "function" then continue end
		amount[i] = v["Amount"].Value;
	end
	
	remote:FireAllClients(nil, "UpdateShop", shop.Upgrades, amount);
end

function shop.Upgrades:CalculateCost(upgrade:string)
	local upgrade = shop.Upgrades[upgrade];
	
	if not upgrade then return end
	
	upgrade["ActualCost"] = math.floor(upgrade["CostFormula"](upgrade["Amount"].Value));
	return upgrade["ActualCost"];
end

shop.Upgrades:GetUpgrades();

return shop
