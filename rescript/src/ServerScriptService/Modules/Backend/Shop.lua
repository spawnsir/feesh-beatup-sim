--[[ local stats = require(game.ServerScriptService.Systems.Server.ServerData);
local remote = game.ReplicatedStorage.Events.ShopRemoteEvent; ]]--

local shop = {}

--[[ shop.Upgrades = {
	Strength = {
		ActualCost = 10,
		CostFormula = function(x:number) return 10 + (15 * x ^ 1.5); end,
		Desc = "Take a bunch of growth hormones to increase your strength!",
		Quote = "I only work out because I really, really like donuts.",
		Decal = "rbxassetid://79019116760485",
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
		local stat:number = stats["Upgrades"][v];
		
		if stat then
			v["Amount"].Value = stat;
		end
	end
end

function shop.Upgrades:BuyUpgrade(upgrade:string)
	local u = shop.Upgrades[upgrade];
	
	-- if not u or stats:GetStat("Money") < u["ActualCost"] then return end
	-- stats:IncrementStat("Money", -u["ActualCost"]);
	-- stats:SetStat("Upgrades", {upgrade, u["Amount"].Value + 1});
	
	u["Amount"].Value = stats["Upgrades"][upgrade];
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

shop.Upgrades:GetUpgrades(); ]]--

return shop
