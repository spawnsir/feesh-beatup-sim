local NPCSystem = {}
NPCSystem.__index = NPCSystem
NPCSystem.AllNPCs = {};

function NPCSystem.new(model)
	
	local npc = setmetatable({}, NPCSystem)
	npc.Character = model;
	npc.State = "Normal";
	
	print("npc created", model);
	
	NPCSystem.AllNPCs[model] = npc;
	model.Destroying:Connect(function() 
		NPCSystem.AllNPCs[model] = nil;
	end)
	
	return npc
	
end

function NPCSystem:MoveTo(targetPosition)
	
	self.Humanoid:MoveTo(targetPosition)
	
end


return NPCSystem
