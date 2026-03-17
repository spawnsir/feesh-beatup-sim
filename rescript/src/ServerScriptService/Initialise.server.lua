local players = game:GetService("Players")

local ragdoll = require(game.ReplicatedStorage.Modules.RagdollSystem)
local shop = require(game.ServerScriptService.System.Shop)

for _, v1 in pairs(game.ReplicatedStorage:GetChildren()) do
	if v1.Name ~= "Koen" then
		continue
	end

	local folder = v1:Clone()
	folder.Parent = workspace

	task.wait()
	for _, v2 in pairs(folder:GetChildren()) do
		ragdoll:SetupModel(v2)
	end
end

for _, v in pairs(game.ServerStorage:GetChildren()) do
	local part = v:Clone()
	part.Parent = workspace
end

players.PlayerAdded:Connect(function(player)
	game.ReplicatedStorage.Events.BadgeEvent:Fire(player, 3375142127527833)

	player.CharacterAdded:Connect(function(char)
		local humanoid = char:WaitForChild("Humanoid")
		humanoid.Died:Connect(function()
			player.Character.State.Value = "Dead"
			ragdoll:Ragdoll(char)
			game.ReplicatedStorage.Events.PlayerEvent:FireAllClients(player, "Death")
		end)
	end)
end)

shop.Upgrades:GetUpgrades()
