local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local NetworkService, MusicService

local InputHandler = {}
InputHandler.Callbacks = {
	Dash = function(...)
		MusicService:PlaySFX(...)
	end,
}

function InputHandler.__init()
	NetworkService, MusicService = ModuleHandler:Get("Network"), ModuleHandler:Get("Music")
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
			local invoke = NetworkService:Invoke("Input", input.Name)

			if not invoke[1] or not InputHandler.Callbacks[input.Name] then
				return
			end

			table.remove(invoke, 1)
			InputHandler.Callbacks[input.Name](unpack(invoke))
		end)
	end
end

return InputHandler
