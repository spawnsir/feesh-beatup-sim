local ServerData = require(game.ServerScriptService.Modules.System.Server.ServerData)

local data = nil

local Settings = {
	Multipliers = {
		Cash = 0,
	},
	Gravity = 196.2,
}

function Settings.__init()
	task.wait(1)
	if ServerData.Data then
		data = ServerData.Data
		Settings.Multipliers.Cash = (data.Upgrades.CashMultiplier or 0) + 1
		Settings.Gravity = Settings.CalculateGravity(data.Upgrades.Gravity or 0)
	end
end

function Settings.CalculateGravity(count)
	return 196.2 - (count * 5)
end

task.spawn(function()
	while true do
		workspace.Gravity = Settings.Gravity
		task.wait(0.1)
	end
end)

return Settings
