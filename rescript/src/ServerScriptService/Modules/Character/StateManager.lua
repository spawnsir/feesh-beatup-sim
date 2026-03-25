local RagdollService, NetworkService =
	require(game:GetService("ReplicatedStorage").Modules.Character.Ragdoll),
	require(game:GetService("ReplicatedStorage").Modules.Backend.Network)

local StateManager = {}
StateManager.__index = StateManager

StateManager.States = {
	IDLE = "Idle",
	RAGDOLL = "Ragdoll",
	DEAD = "Dead",
}

function StateManager.new()
	local self = setmetatable({}, StateManager)

	self.CurrentState = StateManager.States.IDLE

	return self
end

function StateManager:SetState(state, ...)
	self.CurrentState = state

	if state == StateManager.States.IDLE then
		RagdollService:Unragdoll(...)
	end
	if state == StateManager.States.RAGDOLL or state == StateManager.States.DEAD then
		RagdollService:Ragdoll(...)

		if state ~= StateManager.States.DEAD then
			return
		end
		NetworkService:Fire(nil, "Death", ...)
	end
end

return StateManager
