local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local StateManager, RagdollService

local NPCService = {}
NPCService.__index = NPCService
NPCService.NPC_TAG = "NPC"
NPCService.AllNPCs = {}

function NPCService.__init()
	StateManager, RagdollService = ModuleHandler:Get("StateManager"), ModuleHandler:Get("Ragdoll")

	for _, v in ipairs(game:GetService("CollectionService"):GetTagged(NPCService.NPC_TAG)) do
		local v2 = workspace:FindFirstChild(v.Name)
		if not v2 then
			v = v:Clone()
			v.Parent = workspace
		end

		NPCService.new(v)
	end
end

function NPCService.new(model)
	RagdollService:SetupModel(model)

	local self = setmetatable({}, NPCService)

	self.Character = model
	self.State = StateManager.new()
	self.Attributes = model:GetAttributes()

	print("npc created", model)

	NPCService.AllNPCs[model] = self
	model.Destroying:Connect(function()
		NPCService.AllNPCs[model] = nil

		if not self.Attributes["Respawns"] then
			return
		end
		task.delay(5, function()
			print("respawning npc", model.Name)

			local v = model:Clone()

			v.Parent = workspace
			v.PrimaryPart:PivotTo(workspace.Map.Spawn.CFrame + Vector3.new(0, 5, 0))

			NPCService.new(v)
		end)
	end)

	return self
end

function NPCService:MoveTo(pos)
	self.Humanoid:MoveTo(pos)
end

return NPCService
