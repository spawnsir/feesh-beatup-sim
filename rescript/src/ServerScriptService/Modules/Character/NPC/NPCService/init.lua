local StateManager = require(game:GetService("ServerScriptService").Modules.Character.StateManager)

local NPCService = {}
NPCService.__index = NPCService
NPCService.NPC_TAG = "NPC"
NPCService.AllNPCs = {}

function NPCService.new(model)
	local self = setmetatable({}, NPCService)

	self.Character = model
	self.State = StateManager.new()
	self.Attributes = model:GetAttributes()

	print("npc created", model)

	NPCService.AllNPCs[model] = self
	model.Destroying:Connect(function()
		NPCService.AllNPCs[model] = nil
	end)

	return self
end

function NPCService:MoveTo(pos)
	self.Humanoid:MoveTo(pos)
end

return NPCService
