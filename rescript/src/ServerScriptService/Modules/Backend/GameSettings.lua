local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local Data

local data = nil

local Settings = {
	Multipliers = {
		Cash = 0,
	},
	Gravity = 196.2,
}

function Settings.__init()
	Data = ModuleHandler:Get("Data")
end

function Settings.__start()
	task.wait(1)
	data = Data.Variables
	if not data then
		return
	end

	Settings.Multipliers.Cash = (data.Upgrades.CashMultiplier or 0) + 1
	Settings.Gravity = Settings.CalculateGravity(data.Upgrades.Gravity or 0)

	task.spawn(function()
		while true do
			workspace.Gravity = Settings.Gravity
			task.wait(0.1)
		end
	end)
end

function Settings.CalculateGravity(count)
	return 196.2 - (count * 5)
end

return Settings
