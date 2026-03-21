local koen = script.Parent.dinosaurkoenlol;
local click = koen.Hitbox.ClickDetector;

local remote = game.ReplicatedStorage.Events.VFXEvent;

local stats = require(game.ServerScriptService.System.StatsManager);
local shop = require(game.ServerScriptService.System.Shop);
local ragdollSystem = require(game.ReplicatedStorage.Modules.RagdollSystem);
local combo = require(game.ReplicatedStorage.Modules.ComboSystem);

local humanoid = koen.Humanoid;
local hrp = koen.HumanoidRootPart;

local debounce = false;
local cd = 0.05;

for _, v in pairs(script.Parent:GetChildren()) do
	if not v:IsA("Model") then continue end

	ragdollSystem:SetupModel(v);
end

click.MouseClick:Connect(function(player)
	if player.Character.Humanoid.Health <= 0 or player.Character.State.Value == "Dead" then return end
	if not debounce then
		remote:FireAllClients(player, "Hit");
		combo:IncrementCombo(1);
	
		if hrp then
			local lv = Instance.new("LinearVelocity");
			local a = hrp:FindFirstChild("RootAttachment") or hrp:FindFirstChild("Attachment") or Instance.new("Attachment", hrp);

			lv.Parent = hrp;
			lv.MaxForce = 10000;
			lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector;
			lv.RelativeTo = Enum.ActuatorRelativeTo.World;
			lv.Attachment0 = a;
			lv.VectorVelocity = Vector3.new(math.random(-5, 5), 50, math.random(-5, 5));

			game.Debris:AddItem(lv, 0.05);
		end
		
		if koen.State ~= "Ragdolled" then ragdollSystem:Ragdoll(koen); end

		debounce = true;
		task.delay(0.05, function()
			debounce = false;
		end)
	end
	
	
	stats:IncrementStat("Money", math.floor((1 * (1 + shop.Upgrades["Strength"]["Amount"].Value)) * (1 + (0.1 * combo.Combo.Value / 10)^1.1)));
end)