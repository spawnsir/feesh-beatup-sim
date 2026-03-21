local koen = workspace.Koen:WaitForChild("dinosaurkoenlol");

local remote = game.ReplicatedStorage.Events.VFXEvent;

local playlist = game.ReplicatedStorage.Sound:WaitForChild("SFX");

remote.OnClientEvent:Connect(function(player, event)
	if event == "Hit" then
		local sfx = playlist:WaitForChild("Hit"):GetChildren();
		local sound = sfx[math.random(1, #sfx)]:Clone();

		print(player.Name.. ", BEAT HIS ASSSSS!!!!!");

		sound.Parent = koen.HumanoidRootPart;

		local highlight = koen:FindFirstChild("Highlight"):Clone();
		highlight.Parent = koen;

		highlight.FillTransparency = 0;
		highlight.OutlineTransparency = 0;

		local tweenInfo = TweenInfo.new(2.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0);
		local t = game:GetService("TweenService"):Create(highlight, tweenInfo, {FillTransparency = 1, OutlineTransparency = 1});

		t:Play();
		sound:Play();
		
		task.spawn(function()
			t.Completed:Wait();
			highlight:Destroy();
		end)

		sound.Ended:Wait();
		sound:Destroy()
	end
end)
