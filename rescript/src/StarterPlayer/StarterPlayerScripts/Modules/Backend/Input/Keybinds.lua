local Keybinds = {
	Bindings = {},
}

function Keybinds.__start()
	Keybinds:DefaultBindings()
end

function Keybinds:DefaultBindings()
	for _, input in pairs(game:GetService("ReplicatedStorage").Keybinds:GetChildren()) do
		if not input:IsA("InputAction") then
			continue
		end

		self.Bindings[input.Name] = self.Bindings[input.Name] or {}
		for _, key in pairs(input:GetChildren()) do
			self.Bindings[input.Name][key.Name] = key.KeyCode
		end
	end
end

return Keybinds
