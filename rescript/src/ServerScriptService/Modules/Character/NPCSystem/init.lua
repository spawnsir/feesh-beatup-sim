local NPCSystem = {}
NPCSystem.__index = NPCSystem
NPCSystem.NPC_TAG = "NPC"
NPCSystem.AllNPCs = {}

function NPCSystem.new(model)
	local self = setmetatable({}, NPCSystem)
	self.Character = model
	self.State = "Normal"

	print("npc created", model)

	NPCSystem.AllNPCs[model] = self
	model.Destroying:Connect(function()
		NPCSystem.AllNPCs[model] = nil
	end)

	return self
end

function NPCSystem:MoveTo(targetPosition)
	self.Humanoid:MoveTo(targetPosition)
end

return NPCSystem
