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
		ModuleHandler.LoadModules(player.PlayerScripts:WaitForChild("Modules"), "Client")
	end

	if RunService:IsServer() then
		ModuleHandler.LoadModules(game:GetService("ServerScriptService").Packages, "Server")
		ModuleHandler.LoadModules(game:GetService("ServerScriptService").Modules, "Server")
	end

	task.delay(15, function()
		if #ModuleHandler.RequiringModules > 0 then
			warn("Not all modules have loaded!", ModuleHandler.RequiringModules, "Initialising required modules")
			ModuleHandler.start()
		end
	end)

	while #ModuleHandler.RequiringModules > 0 do
		task.wait()
	end
	ModuleHandler.start()

	print("modules loaded! ^v^")
end

function ModuleHandler.LoadModules(modules, context: string?)
	context = context or "Shared"
	for _, module in pairs(modules:GetDescendants()) do
		ModuleHandler.require(module, context)
	end
end

function ModuleHandler.require(module, context)
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
			ModuleHandler.Cache[context] = ModuleHandler.Cache[context] or {}
			ModuleHandler.Cache[context][module.Name] = result
			table.remove(ModuleHandler.RequiringModules, table.find(ModuleHandler.RequiringModules, module))
		else
			warn(`failed to load module: {module.Name} - {result}`)
		end
	end)
end

function ModuleHandler.start()
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

function ModuleHandler:Get(name, useContext: boolean?)
	useContext = useContext or true
	if not ModuleHandler.HasStarted then
		warn(`warning: accessing {name} before module loader has started!`)
	end

	local context = "Shared"
	if useContext then
		context = RunService:IsServer() and "Server" or "Client"
	end

	return ModuleHandler.Cache[context][name] or ModuleHandler.Cache["Shared"][name]
end

return ModuleHandler
