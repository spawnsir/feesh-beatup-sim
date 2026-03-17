-- feeshiest
local CollectionService = game:GetService("CollectionService")
local BaseNPC, RagdollService, NetworkService =
	require(script.Parent),
	require(game.ReplicatedStorage.Modules.Character.Ragdoll),
	require(game.ReplicatedStorage.Modules.Backend.Network)

local SmackableNPC = setmetatable({}, BaseNPC)
SmackableNPC.__index = SmackableNPC
SmackableNPC.NPC_ID = "Feeshiest"

function SmackableNPC.__init()
	for _, v in ipairs(CollectionService:GetTagged(SmackableNPC.NPC_ID)) do
		if not v:IsDescendantOf(workspace) then
			v = v:Clone()
			v.Parent = workspace
		end

		SmackableNPC.new(v)
	end
end

function SmackableNPC.new(model)
	RagdollService:SetupModel(model)
	local npc = setmetatable(BaseNPC.new(model), SmackableNPC)

	npc.Debounce = false
	npc.Cooldown = 0.05
	npc.ClickDetector = model.Hitbox.ClickDetector

	npc.ClickDetector.MouseClick:Connect(function(player)
		npc:OnClick(npc, player)
	end)

	return npc
end

function SmackableNPC:OnClick(npc)
	if npc.Debounce then
		return
	end

	npc.Debounce = true
	NetworkService:Fire(nil, "SmackedNPC", npc.Character)

	local hrp = npc.Character:FindFirstChild("HumanoidRootPart")
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
		npc.Debounce = false
	end)

	if npc.State == "Ragdolled" then
		return
	end

	RagdollService:Ragdoll(npc.Character)
	npc.State = "Ragdolled"
end

return SmackableNPC
