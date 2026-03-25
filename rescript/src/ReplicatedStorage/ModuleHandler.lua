local RunService = game:GetService("RunService")

local ModuleHandler = {}
ModuleHandler.Cache = {}
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
		    ModuleHandler.Cache[module.Name] = module
			print('Loaded module: {module.Name}')
			table.remove(ModuleHandler.RequiringModules, table.find(ModuleHandler.RequiringModules, module))
			if result.__init then
				ModuleHandler.DelayedInits[module.Name] = result.__init
			end
		else
			warn('Failed to load module: {module.Name} - {result}')
		end
	end)
end

function ModuleHandler.RunInits()
	if ModuleHandler.InitsRan then
		return
	end
	ModuleHandler.InitsRan = true
	for module, init in pairs(ModuleHandler.DelayedInits) do
	    local yield = ModuleHandler.Cache[module].WaitForModule
	    if yield then
	        ModuleHandler:WaitForModule(yield, init)
	    else
	        task.spawn(init)
	    end
	end
end

function ModuleHandler:Get(name)
    return self.Cache[name]
end

function ModuleHandler:WaitForModule(module, callback)
    local startTime = tick()
    task.spawn(function()
        local v = self.Cache[module]
        while not v do
            if tick() - startTime >= 5 then
                warn('wait on {module} timed out :c')
                return
            end
            task.wait()
            v = self.Cache[module]
        end
        
        callback()
    end)
end

return ModuleHandler