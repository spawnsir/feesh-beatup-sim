local RunService = game:GetService("RunService")

local ModuleHandler = {}
ModuleHandler.Cache = {}
ModuleHandler.RequiringModules = {}
ModuleHandler.HasStarted = false

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
		ModuleHandler.LoadModules(player.PlayerScripts:WaitForChild("Modules"))
	end

	if RunService:IsServer() then
		ModuleHandler.LoadModules(game:GetService("ServerScriptService").Packages)
		ModuleHandler.LoadModules(game:GetService("ServerScriptService").Modules)
	end

	task.delay(15, function()
		if #ModuleHandler.RequiringModules > 0 then
			warn("Not all modules have loaded!", ModuleHandler.RequiringModules, "Initialising required modules")
			ModuleHandler.Start()
		end
	end)

	while #ModuleHandler.RequiringModules > 0 do
		task.wait()
	end
	ModuleHandler.Start()

	print("modules loaded! ^v^")
end

function ModuleHandler.LoadModules(modules)
	for _, module in pairs(modules:GetDescendants()) do
		ModuleHandler.require(module)
	end
end

function ModuleHandler.require(module)
	if not module:IsA("ModuleScript") then
		return
	end
	table.insert(ModuleHandler.RequiringModules, module)
	task.spawn(function()
		local success, result = pcall(function()
			return require(module)
		end)

		if success then
			print(`loaded module: {module.Name}`)
			ModuleHandler.Cache[module.Name] = result
			table.remove(ModuleHandler.RequiringModules, table.find(ModuleHandler.RequiringModules, module))
		else
			warn(`failed to load module: {module.Name} - {result}`)
		end
	end)
end

function ModuleHandler.Start()
	for v, module in pairs(ModuleHandler.Cache) do
		print(`running init for module: {v}`)

		local init = module.__init
		if not init then
			continue
		end

		task.spawn(init)
	end

	for v, module in pairs(ModuleHandler.Cache) do
		print(`starting module: {v}`)

		local start = module.__start
		if not start then
			continue
		end

		task.spawn(start)
	end

	ModuleHandler.HasStarted = true
end

function ModuleHandler:Get(name)
	if not ModuleHandler.HasStarted then
		warn(`warning: accessing {name} before module loader has started!`)
	end

	return ModuleHandler.Cache[name]
end

return ModuleHandler
