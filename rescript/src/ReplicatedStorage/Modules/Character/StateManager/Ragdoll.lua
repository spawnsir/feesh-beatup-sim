local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local Ragdoll = {}

local RagdollService

function Ragdoll.__init()
	RagdollService = ModuleHandler:Get("RagdollService")
end

function Ragdoll.Do(character)
	if not character or not character.PrimaryPart then
		return
	end

	RagdollService:Ragdoll(character)
end

return Ragdoll
