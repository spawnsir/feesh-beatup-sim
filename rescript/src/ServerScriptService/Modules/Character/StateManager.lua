local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local RagdollService, NetworkService, AbilitySystem

local StateManager = {
	CurrentState = nil,
}
StateManager.__index = StateManager

StateManager.States = {
	IDLE = "Idle",
	RAGDOLL = "Ragdoll",
	DEAD = "Dead",
	DASH = "Dash",
}

StateManager.Callbacks = {}

function StateManager.__init()
	RagdollService, NetworkService, AbilitySystem =
		ModuleHandler:Get("Ragdoll"), ModuleHandler:Get("Network"), ModuleHandler:Get("AbilitySystem")
end

function StateManager.__start()
	StateManager.Callbacks = {
		[StateManager.States.IDLE] = function(...)
			if StateManager.CurrentState ~= StateManager.States.RAGDOLL then
				return
			end
			RagdollService:Unragdoll(...)
		end,

		[StateManager.States.RAGDOLL] = function(...)
			RagdollService:Ragdoll(...)
		end,

		[StateManager.States.DEAD] = function(...)
			RagdollService:Ragdoll(...)

			print(`{...} has seen the light`)
			NetworkService:Fire(nil, "Death", ...)
		end,
	}
end

function StateManager.new()
	local self = setmetatable({}, StateManager)

	self.CurrentState = StateManager.States.IDLE
	self.Cooldowns = {}

	return self
end

function StateManager:SetState(state, ...)
	local ability = AbilitySystem:GetAbility(state)
	if ability and (not self.Cooldowns[state] or self.Cooldowns[state] == false) then
		AbilitySystem:UseAbility(state, ...)
	end

	if StateManager.Callbacks[state] then
		StateManager.Callbacks[state](...)
	end

	self.CurrentState = state
end

return StateManager
