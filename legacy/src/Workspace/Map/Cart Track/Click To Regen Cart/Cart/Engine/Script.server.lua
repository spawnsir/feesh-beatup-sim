function blow()
	for i = 1, 4 do
		if script.Parent:FindFirstChild("Engine") ~= nil then
			local ex = Instance.new("Explosion")
			ex.Position = script.Parent.Parent.Engine.Position + Vector3.new(math.random(-3, 3), math.random(-3, 3), math.random(-3, 3))
			ex.BlastRadius = 1
			ex.BlastPressure = 1000
			ex.Parent = game.Workspace
			wait()
		end
	end
	wait(1)
	script.Parent.Parent:remove()
end

script.Parent.Parent.ChildRemoved:connect(blow)

while true do
	wait(0.1)
	if script.Parent.Parent.CarOn.Value == true then
		local look = script.Parent.CFrame.lookVector*script.Parent.Parent.Speed.Value
		script.Parent.BV.velocity = Vector3.new(look.x, -15, look.z)
		else
		script.Parent.BV.velocity = Vector3.new(0, -5, 0)
	end
end
