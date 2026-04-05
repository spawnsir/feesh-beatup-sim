local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)
local Behaviours = require(script.Parent.Behaviours)

local StateManager, RagdollService

local NPCService = {}
NPCService.__index = NPCService
NPCService.NPC_TAG = "NPC"
NPCService.AllNPCs = {}

local behaviours = Behaviours

function NPCService.__init()
	StateManager, RagdollService = ModuleHandler:Get("StateManager"), ModuleHandler:Get("RagdollService")
end

function NPCService.__start()
	for _, v in ipairs(game:GetService("CollectionService"):GetTagged(NPCService.NPC_TAG)) do
		if not v:IsDescendantOf(workspace) and not workspace.Map.NPCs:FindFirstChild(v.Name) then
			v = v:Clone()
			v.Parent = workspace.Map.NPCs
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
	self.Behaviours = self:SetBehaviours(self.Attributes)

	print("npc created", model)

	if self.Attributes["AvatarId"] then
		self:ApplyAvatarFromID(self.Attributes["AvatarId"], model)
	end

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

function NPCService:SetBehaviours(attributes)
	local t = {}

	for i, v in pairs(behaviours) do
		if attributes[i] and v then
			print(`setting behaviour {i} for npc {self.Character.Name}`)
			t[i] = v.new(self)
		end
	end
	return t
end

function NPCService:MoveTo(pos)
	self.Humanoid:MoveTo(pos)
end

function NPCService:ApplyAvatarFromID(id, model)
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	local description = game:GetService("Players"):GetHumanoidDescriptionFromUserId(id)
	if not humanoid or not description then
		return
	end

	humanoid:ApplyDescription(description)
end

return NPCService
