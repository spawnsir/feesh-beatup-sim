local koen = workspace:WaitForChild("Koen").dinosaurkoenlol;
local raycastParams = RaycastParams.new();

local combo = require(game.ReplicatedStorage.Modules.ComboSystem);

raycastParams.FilterDescendantsInstances = {koen};
raycastParams.FilterType = Enum.RaycastFilterType.Include;
raycastParams.IgnoreWater = true;

local function isGrounded()
	local part = script.Parent;
	local rayDirection = part.CFrame.UpVector * 0.5;
	local raycastResult = workspace:Blockcast(part.CFrame, part.Size, rayDirection, raycastParams);
	
	return raycastResult ~= nil;
end

game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
	if not isGrounded() or combo.Combo.Value <= 0 then return end
	combo:EndCombo();
end)