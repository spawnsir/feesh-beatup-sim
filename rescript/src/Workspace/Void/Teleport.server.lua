--local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

--local BadgeService = ModuleHandler:Get("BadgeService")

script.Parent.Touched:Connect(function(hit)
	print(hit)
	if not hit:IsA("BasePart") then
		return
	end

	if hit then
		hit:PivotTo(workspace:WaitForChild("Map").Spawn.CFrame + Vector3.new(0, 5, 0))
		hit.AssemblyLinearVelocity = Vector3.zero
		hit.AssemblyAngularVelocity = Vector3.zero

		hit.Anchored = true
		hit.Anchored = false
	end

	if hit.Parent.Parent.Name ~= "Koen" then
		return
	end

	--[[ 
	task.spawn(function()
		for _, player in pairs(game.Players:GetPlayers()) do
			BadgeService:AwardBadge(player, 331640616438274)
		end
	end) 
	]]
	--
end)
