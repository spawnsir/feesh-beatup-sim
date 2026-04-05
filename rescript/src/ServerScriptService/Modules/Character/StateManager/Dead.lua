local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local Dead = {}

local RagdollService, NetworkService

function Dead.__init()
	RagdollService, NetworkService = ModuleHandler:Get("RagdollService"), ModuleHandler:Get("Network")
end

function Dead.Do(character)
	if not character or not character.PrimaryPart then
		return
	end

	RagdollService:Ragdoll(character)

	print(`{character} has seen the light`)
	NetworkService:Fire(nil, "PlaySFX", character, "Death", true)
end

return Dead
