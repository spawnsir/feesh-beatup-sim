local remote = game.ReplicatedStorage.Events.BadgeEvent;
local badge = game:GetService("BadgeService");

remote.Event:Connect(function(player, badgeId)
	local success, hasBadge = pcall(function()
		return badge:UserHasBadgeAsync(player.UserId, badgeId);
	end)
	print(success, hasBadge)
	
	if not success or hasBadge then return end
	badge:AwardBadgeAsync(player.UserId, badgeId);
end)
