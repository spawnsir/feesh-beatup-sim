local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local NetworkService

local InputHandler = {}

function InputHandler.__init()
	NetworkService = ModuleHandler:Get("Network")
end

function InputHandler.__start()
	InputHandler:BindInputs()
end

function InputHandler:BindInputs()
	for _, input in pairs(game:GetService("ReplicatedStorage").Keybinds:GetChildren()) do
		if not input:IsA("InputAction") then
			continue
		end

		input.Pressed:Connect(function()
			NetworkService:Fire("Input", input.Name)
		end)
	end
end

return InputHandler
