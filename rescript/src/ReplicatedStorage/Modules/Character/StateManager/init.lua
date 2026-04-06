local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local AbilitySystem

local StateManager = {
	CurrentState = nil,
}
StateManager.__index = StateManager
StateManager.Modules = {}
StateManager.Abilities = {}

StateManager.States = {
	IDLE = "Idle",
	RAGDOLL = "Ragdoll",
	DEAD = "Dead",
	DASH = "Dash",
}

function StateManager.__init()
	AbilitySystem = ModuleHandler:Get("AbilitySystem")
end

function StateManager.__start()
	for _, state in pairs(StateManager.States) do
		print(`loading state module for {state}`)
		local module = script:FindFirstChild(state) and require(script:FindFirstChild(state))
		if not module then
			continue
		end

		StateManager.Modules[state] = module
		print(`loaded state module for {state}`)
	end

	StateManager.Abilities = AbilitySystem.Abilities
end

function StateManager.new()
	local self = setmetatable({}, StateManager)

	self.CurrentState = StateManager.States.IDLE

	return self
end

function StateManager:SetState(state, ...)
	if self.Modules[state] then
		self.Modules[state].Do(...)
	end

	local ability = self.Abilities[state]
	if ability then
		AbilitySystem:UseAbility(state, ...)
	end

	self.CurrentState = state
end

return StateManager
