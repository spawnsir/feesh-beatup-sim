local combo = {
	Combo = Instance.new("IntValue"),
	AwardBadge = {
		["10"] = 2569008486776017, 
		["100"] = 3810708877416104, 
		["250"] = 448469937070338
	}
}

local remote = game.ReplicatedStorage.Events.ComboEvent;

combo.Combo.Value = 0;

function combo:EndCombo() 
	combo.Combo.Value = 0;
end

function combo:SetCombo(value)
	combo.Combo.Value = value;
end

function combo:IncrementCombo(value)
	combo.Combo.Value += value;
end

combo.Combo.Changed:Connect(function()
	remote:FireAllClients(combo.Combo.Value)
	
	if combo.AwardBadge[tostring(combo.Combo.Value)] then
		for _, player in pairs(game.Players:GetPlayers()) do
			game.ReplicatedStorage.Events.BadgeEvent:Fire(player, combo.AwardBadge[tostring(combo.Combo.Value)]);
		end
	end
end)


return combo
