local NPCSystem = {}
NPCSystem.__index = NPCSystem
NPCSystem.NPC_TAG = "NPC"
NPCSystem.AllNPCs = {}

function NPCSystem.new(model)
	local self = setmetatable({}, NPCSystem)
	self.Character = model
	self.State = "" --TODO: state system
	self.Attributes = model:GetAttributes()

	print("npc created", model)

	NPCSystem.AllNPCs[model] = self
	model.Destroying:Connect(function()
		NPCSystem.AllNPCs[model] = nil
	end)

	return self
end

function NPCSystem:MoveTo(pos)
	self.Humanoid:MoveTo(pos)
end

return NPCSystem
