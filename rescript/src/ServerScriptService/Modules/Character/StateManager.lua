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
		[StateManager.States.IDLE] = function(character)
			if StateManager.CurrentState ~= StateManager.States.RAGDOLL then
				return
			end
			RagdollService:Unragdoll(character)
		end,

		[StateManager.States.RAGDOLL] = function(character)
			RagdollService:Ragdoll(character)
		end,

		[StateManager.States.DEAD] = function(character)
			RagdollService:Ragdoll(character)

			print(`{character} has seen the light`)
			NetworkService:Fire(nil, "PlaySFX", character, "Death", true)
		end,
	}
end

function StateManager.new()
	local self = setmetatable({}, StateManager)

	self.CurrentState = StateManager.States.IDLE

	return self
end

function StateManager:SetState(state, ...)
	if self.Callbacks[state] then
		self.Callbacks[state](...)
	end

	local ability = AbilitySystem:GetAbility(state)
	if ability then
		AbilitySystem:UseAbility(state, ...)
	end

	self.CurrentState = state
end

return StateManager
