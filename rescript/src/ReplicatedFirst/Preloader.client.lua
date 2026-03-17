local ContentProvider = game:GetService("ContentProvider");

local assets = game.ReplicatedStorage:WaitForChild("Assets"):GetDescendants();
local totalAssets = #assets;

for i, v in ipairs(assets) do
	-- print("loading asset: " ..i.. "/" ..totalAssets, v)
	ContentProvider:PreloadAsync({v});
end

print("game loaded!");