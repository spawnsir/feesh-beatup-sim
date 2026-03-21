function add(p)
	script.Parent.ChildRemoved:connect(function()
		local a = script.Parent.Parent.Safe:FindFirstChild("SeatWeld")
		if a ~= nil then return end
		script.Parent.Parent:remove()
	end)
	--[[for i = 1, 6 do
		local ex = Instance.new("Explosion")
		ex.Position = script.Parent.Position + Vector3.new(math.random(-3, 3), math.random(-3, 3), math.random(-3, 3))
		ex.BlastRadius = 2
		ex.BlastPressure = 1000
		ex.Parent = game.Workspace
		wait()
	end--]]
end

script.Parent.ChildAdded:connect(add)
