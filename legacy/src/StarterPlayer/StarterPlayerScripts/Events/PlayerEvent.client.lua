local playlist = game.ReplicatedStorage.Sound:WaitForChild("SFX");

game.ReplicatedStorage.Events.PlayerEvent.OnClientEvent:Connect(function(player, event)
	print(event);
	
	if event == "Death" then
		print(player.Name.. " has seen the light");
		local hrp = player.Character:FindFirstChild("HumanoidRootPart");
		local sound = playlist.Death:Clone();
		
		sound.Parent = hrp;
		sound:Play()
		
		task.spawn(function()
			sound.Ended:Wait();
			sound:Destroy()
		end)
	end
end)