local RagdollService = {}

function RagdollService:BuildJoints(model: Model)
	self:DestroyJoints(model)

	for _, v in pairs(model:GetDescendants()) do
		if not v:IsA("Motor6D") or v:FindFirstAncestorOfClass("Accessory") or v.Name == "HumanoidRootPart" then
			continue
		end

		local socket: BallSocketConstraint = Instance.new("BallSocketConstraint")
		local a0: Attachment, a1: Attachment = Instance.new("Attachment"), Instance.new("Attachment")

		a0.Parent = v.Part0
		a0.CFrame = v.C0

		a1.Parent = v.Part1
		a1.CFrame = v.C1

		socket.Parent = v.Parent
		socket.Attachment0 = a0
		socket.Attachment1 = a1

		socket.LimitsEnabled = true
		socket.TwistLimitsEnabled = true
	end
end

function RagdollService:DestroyJoints(model: Model)
	for _, v in pairs(model:GetDescendants()) do
		if v:IsA("BallSocketConstraint") or v.Name == "Attachment" then
			v:Destroy()
		end
	end
end

function RagdollService:BuildCollisions(model: Model)
	for _, v in pairs(model:GetChildren()) do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" and v.Name ~= "Hitbox" then
			local h = v:Clone()
			h.Parent = v
			h.CanCollide = false
			h.Massless = true
			h.Size = Vector3.one
			h.Name = "Collision"
			h.Transparency = 1
			h:ClearAllChildren()

			local w = Instance.new("Weld")
			w.Parent = h
			w.Part0 = v
			w.Part1 = h
		end
	end
end

function RagdollService:Ragdoll(model: Model, duration: number?)
	local hum = model:FindFirstChildOfClass("Humanoid")
	local hrp = model:FindFirstChild("HumanoidRootPart")

	local player: Player = game.Players:GetPlayerFromCharacter(model)

	hum.RequiresNeck = false

	self:BuildJoints(model)
	self:EnableMotor6D(model, false)
	self:EnableCollisions(model, true)

	if not player then
		hrp:SetNetworkOwner(nil)
	end
	hum.AutoRotate = false
	hum.PlatformStand = true

	if duration then
		task.delay(duration, function()
			self:Unragdoll(model)
		end)
	end
end

function RagdollService:Unragdoll(model: Model)
	local hum = model:FindFirstChildOfClass("Humanoid")

	hum.RequiresNeck = true

	self:DestroyJoints(model)
	self:EnableMotor6D(model, true)
	self:EnableCollisions(model, false)

	hum.AutoRotate = true
	hum.PlatformStand = false
end

function RagdollService:EnableCollisions(model: Model, enabled: boolean)
	for _, v in pairs(model:GetChildren()) do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" and v.Name ~= "Hitbox" then
			v.CanCollide = not enabled
			v.Collision.CanCollide = enabled
		end
	end
end

function RagdollService:EnableMotor6D(model: Model, enabled: boolean)
	for _, v in pairs(model:GetDescendants()) do
		if v:IsA("Motor6D") then
			v.Enabled = enabled
		end
	end
end

function RagdollService:SetupHumanoid(hum: Humanoid)
	if not hum then
		return
	end
	hum.BreakJointsOnDeath = false
end

function RagdollService:SetupModel(model: Model)
	local hum = model:FindFirstChildOfClass("Humanoid")
	self:SetupHumanoid(hum)
	self:BuildCollisions(model)
end

return RagdollService
