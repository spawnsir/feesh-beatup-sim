local AbilitySystem = {
	Abilities = {},
}

function AbilitySystem.__start()
	AbilitySystem:GetAbilities()
end

function AbilitySystem:GetAbilities()
	for _, ability in pairs(script:GetChildren()) do
		if ability:IsA("ModuleScript") then
			local module = require(ability)
			if not module then
				return
			end

			self.Abilities[ability.Name] = module
		end
	end
end

function AbilitySystem:GetAbility(name)
	return self.Abilities[name]
end

function AbilitySystem:UseAbility(name, player, ...)
	local ability = self:GetAbility(name)

	if not ability then
		return
	end

	print(`using ability: {name}`)
	if ability.Cooldown then
		player.Debounces[name] = true
		task.delay(ability.Cooldown, function()
			player.Debounces[name] = false
		end)
	end

	ability.Activate(player, ...)
end

function AbilitySystem.CanUse(state)
	print(state)
	if state == "Dead" or state == "Ragdoll" then
		return
	end

	return true
end

return AbilitySystem
