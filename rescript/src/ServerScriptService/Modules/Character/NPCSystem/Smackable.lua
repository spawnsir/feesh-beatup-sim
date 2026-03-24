-- feeshiest
local CollectionService = game:GetService("CollectionService")
local BaseNPC, RagdollService, NetworkService, ServerData, GameSettings =
	require(script.Parent),
	require(game.ReplicatedStorage.Modules.Character.Ragdoll),
	require(game.ReplicatedStorage.Modules.Backend.Network),
	require(game.ServerScriptService.Modules.System.Server.ServerData),
	require(game.ServerScriptService.Modules.System.GameSettings)

local SmackableNPC = setmetatable({}, BaseNPC)
SmackableNPC.__index = SmackableNPC
SmackableNPC.NPC_ID = "Smackable"

function SmackableNPC.__init()
	for _, v in ipairs(CollectionService:GetTagged(BaseNPC.NPC_TAG)) do
		if v:GetAttribute("NPCType") ~= SmackableNPC.NPC_ID then
			continue
		end
		if not v:IsDescendantOf(workspace) then
			v = v:Clone()
			v.Parent = workspace
		end

		SmackableNPC.new(v)
	end
end

function SmackableNPC.new(model)
	RagdollService:SetupModel(model)
	local self = setmetatable(BaseNPC.new(model), SmackableNPC)

	self.Debounce = false
	self.Cooldown = 0.05

	local hitbox = SmackableNPC:Hitbox()
	self.ClickDetector = hitbox:FindFirstChild("ClickDetector") or Instance.new("ClickDetector")
	self.ClickDetector.Parent = hitbox

	self.ClickDetector.MouseClick:Connect(function()
		self:OnClick()
	end)

	return self
end

function SmackableNPC:CreateHitbox()
	if not self.Character then
		return
	end

	if self.Character:FindFirstChild("Hitbox") then
		return self.Character.Hitbox
	end

	local hitbox = Instance.new("Part")
	hitbox.Name = "Hitbox"
	hitbox.Parent = self.Character

	hitbox.Size = Vector3.new(5, 7, 4)
	hitbox.CFrame = self.Character:GetPrimaryPartCFrame()
	hitbox.Color = Color3.new(1, 0, 0)
	hitbox.Transparency = 1

	hitbox.Massless = true
	hitbox.CanCollide = false
	hitbox.CanTouch = false
	hitbox.AudioCanCollide = false

	local weld = Instance.new("WeldConstraint")
	weld.Parent = hitbox
	weld.Part0 = hitbox
	weld.Part1 = self.Character.Torso

	return hitbox
end

function SmackableNPC:OnClick()
	if self.Debounce then
		return
	end

	self.Debounce = true
	NetworkService:Fire(nil, "SmackedNPC", npc.Character)

	if npc.Character:GetAttribute("Dropper") then
		ServerData:SetDataValue("Cash", ServerData.Data.Cash + 1 * GameSettings.Multipliers.Cash)
	end

	local hrp = self.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		local lv = Instance.new("LinearVelocity")
		local a = hrp:FindFirstChild("RootAttachment") or hrp:FindFirstChild("Attachment") or Instance.new("Attachment")

		lv.Parent = hrp
		lv.MaxForce = 10000
		lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
		lv.RelativeTo = Enum.ActuatorRelativeTo.World
		lv.Attachment0 = a
		lv.VectorVelocity = Vector3.new(math.random(-5, 5), 50, math.random(-5, 5))

		game.Debris:AddItem(lv, 0.05)
	end

	task.delay(npc.Cooldown, function()
		self.Debounce = false
	end)

	RagdollService:Ragdoll(npc.Character)
end

return SmackableNPC
