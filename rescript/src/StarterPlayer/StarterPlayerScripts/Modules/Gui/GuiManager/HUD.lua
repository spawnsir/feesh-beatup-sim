local GuiManager = require(script.Parent)

local HUD = {}

local frame = nil

function HUD.__init()
	frame = GuiManager:GetFrame("HUD", "Stats")

	task.spawn(function()
		while true do
			for _, v in pairs(frame:GetChildren()) do
				if not v:IsA("TextLabel") then
					continue
				end

				local value = game.ReplicatedStorage.Stats:FindFirstChild(v.Name)
				if not value then
					continue
				end

				v.Text = v.Name .. ": " .. value.Value
			end
			task.wait(0.1)
		end
	end)
end

return HUD
