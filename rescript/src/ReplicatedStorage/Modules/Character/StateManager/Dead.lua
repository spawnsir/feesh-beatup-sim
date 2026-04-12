local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local Dead = {}

local RagdollService, MusicService

function Dead.__init()
	RagdollService = ModuleHandler:Get("RagdollService")

	if game:GetService("RunService"):IsClient() then
		MusicService = ModuleHandler:Get("MusicService")
	else
		MusicService = ModuleHandler:Get("MusicServiceServer")
	end
end

function Dead.Do(character)
	if not character or not character.PrimaryPart then
		return
	end

	RagdollService:Ragdoll(character)

	print(`{character} has seen the light`)
	task.spawn(function()
		local args = {
			"Death",
			character.HumanoidRootPart,
			true,
			false,
		}

		if game:GetService("RunService"):IsServer() then
			table.insert(args, character)
		end

		MusicService:PlaySFX(table.unpack(args))
	end)
end

return Dead
