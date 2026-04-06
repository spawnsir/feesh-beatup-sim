local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local Idle = {}

local RagdollService

function Idle.__init()
	RagdollService = ModuleHandler:Get("RagdollService")
end

function Idle.Do(character)
	if not character or not character.PrimaryPart then
		return
	end

	RagdollService:Unragdoll(character)
end

return Idle
