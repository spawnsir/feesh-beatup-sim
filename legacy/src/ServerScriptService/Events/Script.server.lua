local TeleportService = game:GetService("TeleportService")
local remote = game.ReplicatedStorage.Events.PlayerEvent;

remote.OnServerEvent:Connect(function(player, action)
	if action == "Teleport" then
		TeleportService:Teleport(139216498402293, player);
	end
end)
