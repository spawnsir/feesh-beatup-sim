local RunService = game:GetService("RunService")

local ModuleHandler = {}
ModuleHandler.RequiringModules = {}
ModuleHandler.DelayedInits = {}
ModuleHandler.InitsRan = false

function ModuleHandler.init()
	print("loading modulleeess")

	local rs = game:GetService("ReplicatedStorage")
	local modules = rs:WaitForChild("Modules")

	for _, module in pairs(modules:GetDescendants()) do
		if module == script then
			continue
		end
		ModuleHandler.require(module)
	end

	if RunService:IsClient() then
		local player = game:GetService("Players").LocalPlayer
		for _, module in pairs(player.PlayerScripts:WaitForChild("Modules"):GetDescendants()) do
			ModuleHandler.require(module)
		end
	end

	if RunService:IsServer() then
		for _, module in pairs(game:GetService("ServerScriptService").Modules:GetDescendants()) do
			ModuleHandler.require(module)
		end
	end

	task.delay(15, function()
		if #ModuleHandler.RequiringModules > 0 then
			warn("Not all modules have loaded!", ModuleHandler.RequiringModules, "Initialising required modules")
			ModuleHandler.RunInits()
		end
	end)

	while #ModuleHandler.RequiringModules > 0 do
		task.wait()
	end
	ModuleHandler.RunInits()

	print("modules loaded! ^v^")
end

function ModuleHandler.require(module)
	if module.ClassName ~= "ModuleScript" then
		return
	end
	table.insert(ModuleHandler.RequiringModules, module)
	task.spawn(function()
		local success, result = pcall(function()
			return require(module)
		end)

		if success then
			print("Loaded module: " .. module.Name)
			table.remove(ModuleHandler.RequiringModules, table.find(ModuleHandler.RequiringModules, module))
			if result.__init then
				ModuleHandler.DelayedInits[module.Name] = result.__init
			end
		else
			warn("Failed to load module: " .. module.Name .. " - " .. result)
		end
	end)
end

function ModuleHandler.RunInits()
	if ModuleHandler.InitsRan then
		return
	end
	ModuleHandler.InitsRan = true
	for _, init in pairs(ModuleHandler.DelayedInits) do
		task.spawn(init)
	end
end

return ModuleHandler
