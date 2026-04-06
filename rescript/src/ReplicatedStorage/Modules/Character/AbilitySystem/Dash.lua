local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local Constants, MusicService

local Dash = {
	Cooldown = nil,
	SFX = "Dash",
}

function Dash.__init()
	Constants = ModuleHandler:Get("Constants")

	if game:GetService("RunService"):IsClient() then
		MusicService = ModuleHandler:Get("Music")
	else
		MusicService = ModuleHandler:Get("MusicServiceServer")
	end
end

function Dash.__start()
	Dash.Cooldown = Constants.DASH_COOLDOWN
end

function Dash.Do(player)
	local character = player.Character
	if not character or not character.PrimaryPart then
		return
	end

	local hum = character.Humanoid
	local root = character.HumanoidRootPart

	task.spawn(function()
		local args = {
			Dash.SFX,
			root,
			false,
			false,
		}

		if game:GetService("RunService"):IsServer() then
			table.insert(args, character)
		end

		MusicService:PlaySFX(table.unpack(args))
	end)

	local attach = root:FindFirstChild("ForceAttachumment")
	if not attach then
		attach = Instance.new("Attachment")
		attach.Name = "ForceAttachment"
		attach.Parent = root
	end

	root.Velocity *= Vector3.new(1, 0, 1)
	root.RotVelocity *= Vector3.new(1, 0, 1)

	local velocity = Instance.new("LinearVelocity")
	velocity.Attachment0 = attach
	velocity.RelativeTo = Enum.ActuatorRelativeTo.World
	velocity.MaxForce = Constants.DASH_STRENGTH * 1000
	velocity.VectorVelocity = root.CFrame.LookVector * Constants.DASH_STRENGTH
	velocity.ForceLimitMode = Enum.ForceLimitMode.Magnitude
	velocity.Parent = attach.Parent

	if hum.FloorMaterial == Enum.Material.Air then
		velocity.VectorVelocity += Vector3.new(0, 2, 0)
	end

	local connect = game:GetService("RunService").Heartbeat:Connect(function()
		local params = RaycastParams.new()
		params.IgnoreWater = true
		local result = workspace:Raycast(root.CFrame.Position, root.CFrame.LookVector * 5, params)
		if result then
			velocity:Destroy()
			root.Anchored = true
			task.wait(1)
			root.Anchored = false
		end
	end)

	game.Debris:AddItem(velocity, 0.1)
	task.wait(0.1)
	game:GetService("RunService").Heartbeat:Wait()

	connect:Disconnect()
end

return Dash
