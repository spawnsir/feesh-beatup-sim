local contentProvier = game:GetService("ContentProvider");

local sounds = game.ReplicatedStorage:WaitForChild("Sound"):FindFirstChild("SFX");

for _, v in pairs(sounds:GetDescendants()) do
	if v:IsA("Sound") then
		contentProvier:PreloadAsync({v});
	end
end
