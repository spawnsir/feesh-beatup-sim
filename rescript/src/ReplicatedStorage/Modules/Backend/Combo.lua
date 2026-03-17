local combo = {
	Combo = Instance.new("IntValue"),
}

local remote = game.ReplicatedStorage.Events.ComboEvent

combo.Combo.Value = 0

function combo:EndCombo()
	combo.Combo.Value = 0
end

function combo:SetCombo(value)
	combo.Combo.Value = value
end

function combo:IncrementCombo(value)
	combo.Combo.Value += value
end

combo.Combo.Changed:Connect(function()
	remote:FireAllClients(combo.Combo.Value)

	if combo.Combo.Value == 10 or combo.Combo.Value == 100 then
		local id = 2569008486776017
		if combo.Combo.Value == 100 then
			id = 3810708877416104
		end

		for _, player in pairs(game.Players:GetPlayers()) do
			game.ReplicatedStorage.Events.BadgeEvent:Fire(player, id)
		end
	end
end)

return combo
