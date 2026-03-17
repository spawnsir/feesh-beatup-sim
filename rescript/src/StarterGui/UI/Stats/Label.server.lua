local stats = require(game.ServerScriptService.System.StatsManager);

local screenGui = script.Parent;
local textLabel = screenGui.TextLabel;

game:GetService("RunService").Heartbeat:Connect(function()
	textLabel.Text = "Money: " ..tostring(stats["Money"]);
end)