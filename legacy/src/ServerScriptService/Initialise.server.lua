local players = game:GetService("Players");
local badge = game:GetService("BadgeService");

local ragdoll = require(game.ReplicatedStorage.Modules.RagdollSystem);
local shop = require(game.ServerScriptService.System.Shop);

local GROUP_ID = 109654349;
local RANK_TO_KICK = 253;

for i, v in pairs(game.ReplicatedStorage:GetChildren()) do	
	if v.Name ~= "Koen" then continue end
	
	local folder = v:Clone();
	folder.Parent = workspace;
	
	task.wait();
	for _, v in pairs(folder:GetChildren()) do
		ragdoll:SetupModel(v);
	end
end

for i, v in pairs(game.ServerStorage:GetChildren()) do	
	local part = v:Clone();
	part.Parent = workspace;
end

for _, player in pairs(players:GetPlayers()) do
	if not player:IsInGroupAsync(GROUP_ID) or player:GetRankInGroupAsync(GROUP_ID) <= RANK_TO_KICK then
		player:Kick("not authorised,,,, sorry!!")
	end
end

players.PlayerAdded:Connect(function(player)
	if not player:IsInGroupAsync(GROUP_ID) or player:GetRankInGroupAsync(GROUP_ID) <= RANK_TO_KICK then
		player:Kick("not authorised,,,, sorry!!")
		return
	end
	
	game.ReplicatedStorage.Events.BadgeEvent:Fire(player, 3375142127527833);
	
	player.CharacterAdded:Connect(function(char)
		local humanoid = char:WaitForChild("Humanoid")
		humanoid.Died:Connect(function()
			player.Character.State.Value = "Dead";
			ragdoll:Ragdoll(char);
			game.ReplicatedStorage.Events.PlayerEvent:FireAllClients(player, "Death");
		end)
	end)
end)

shop.Upgrades:GetUpgrades();
