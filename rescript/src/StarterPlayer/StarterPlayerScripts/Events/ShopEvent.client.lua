local tween = game:GetService("TweenService");
local starterGui = game:GetService("StarterGui");
local run = game:GetService("RunService");

local event = game.ReplicatedStorage.Events.ShopEvent;

local camera = workspace.CurrentCamera;
local player = game.Players.LocalPlayer;

local storedCFrame = camera.CFrame;

local shop = player.PlayerGui:WaitForChild("UI").Shop;
local lookAt = workspace.Map.Shop:WaitForChild("CameraRootPosition").CFrame;

local tweens = {}

game.ReplicatedStorage.Events.ShopRemoteEvent.OnClientEvent:Connect(function(player, event)
	print(event);

	if event == "OpenShop" then
		print("open the floodgates");
	
		shop.Enabled = true;
		shop.Select.Frame.Visible = true;
		
		storedCFrame = camera.CFrame;

		camera.CameraType = Enum.CameraType.Scriptable;

		player.Character.HumanoidRootPart.Anchored = true;
		player.Character.Humanoid.PlatformStand = true;
		player.Character.Humanoid.AutoRotate = false;
		
		starterGui:SetCore("ResetButtonCallback", false);
		
		for _, v in pairs(tweens) do
			v:Cancel();
		end
		
		local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0);
		local t0 = tween:Create(camera, tweenInfo, {CFrame = lookAt});
		t0:Play();
		table.insert(tweens, t0);
		
		task.spawn(function()
			tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0);
			for _, player in pairs(game.Players:GetPlayers()) do
				for _, v in pairs(player.Character:GetDescendants()) do
					if not v:IsA("BasePart") and not v:IsA("Decal") and v.Name ~= "Handle" or v.Name == "Hitbox" then continue end
					local t1 = tween:Create(v, tweenInfo, {Transparency = 1});
					t1:Play();
					table.insert(tweens, t1);
				end
			end
		end)

		for _, v in pairs(workspace.Map:WaitForChild("Shop"):GetDescendants()) do
			if not v:IsA("ProximityPrompt") then continue end
			v.Enabled = false;
		end
	end

end)

game.ReplicatedStorage.Events.ShopEvent.Event:Connect(function(event)
	print(event);
	if event == "CloseShop" then
		shop.Enabled = false;
		shop.Select.Frame.Visible = false;

		camera.CameraSubject = player.Character.Humanoid;
		
		player.Character.HumanoidRootPart.Anchored = false;
		player.Character.Humanoid.PlatformStand = false;
		player.Character.Humanoid.AutoRotate = true;
		
		starterGui:SetCore("ResetButtonCallback", true);
		
		for _, v in pairs(tweens) do
			v:Cancel();
		end

		local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0);
		
		local elapsed = 0;
		local cf = CFrame.identity;
		
		camera.CameraType = Enum.CameraType.Custom;
		
		local connect = run.PostSimulation:Connect(function()
			camera.CFrame = cf;
		end)
		
		local function updateTween(deltaTime:number)
			cf = camera.CFrame;
			
			elapsed += deltaTime
			if elapsed >= tweenInfo.Time then
				elapsed = tweenInfo.Time;
				run:UnbindFromRenderStep("TweenBack");
				connect:Disconnect();
				return
			end
			
			local value = tween:GetValue(
				elapsed / tweenInfo.Time,
				tweenInfo.EasingStyle,
				tweenInfo.EasingDirection
			);
			
			camera.CFrame = lookAt:Lerp(cf, value);
		end
		
		run:BindToRenderStep("TweenBack", Enum.RenderPriority.Camera.Value + 1, updateTween)

		task.spawn(function()
			for _, player in pairs(game.Players:GetPlayers()) do
				for _, v in pairs(player.Character:GetDescendants()) do
					if not v:IsA("BasePart") and not v:IsA("Decal") and v.Name ~= "Handle" or v.Name == "Collision" or v.Name == "HumanoidRootPart" then continue end
					local t1 = tween:Create(
						v, 
						TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0), 
						{Transparency = 0}
					);
					t1:Play();
					table.insert(tweens, t1);
				end
			end
		end)

		for _, v in pairs(workspace.Map:WaitForChild("Shop"):GetDescendants()) do
			if not v:IsA("ProximityPrompt") then continue end
			v.Enabled = true;
		end
		
	end
end)

