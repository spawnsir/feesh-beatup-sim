local BadgeService = game:GetService("BadgeService")

local BadgeHandler = {}

function BadgeHandler:AwardBadge(player, id)
    local userId = player.UserId
    if not self.GetBadge(id) or self.HasBadge(userId, id) then
        return
    end
    
    local success, result = pcall(function()
        BadgeService:AwardBadgeAsync(userId, id)
    end)
    
    if not success then
        warn('unable to award badge {id} to {player.Name}')
    end
end

function BadgeHandler.GetBadge(id)
    local success, info = pcall(function()
        return BadgeService:GetBadgeInfoAsync(id)
    end)
    
    if not success or not info.IsEnabled then
        warn('badge {id} is not enabled or could not be found :P')
    end
    
    return info
end

function BadgeHandler.HasBadge(player, id)
    local success, own = pcall(function()
        return BadgeService:UserHasBadgeAsync(player, id)
    end)
    
    if not success then
        warn('unable to check if player owns badge {id}')
        return true
    end
    
    if own then
        warn('player owns badge {id}')
    end
    
    return own
end

return BadgeHandler