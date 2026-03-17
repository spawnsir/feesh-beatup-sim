game.ReplicatedStorage.Events.RagdollEvent.OnClientEvent:Connect(function(event, model)
	print(model);
	if event ~= "CreateRagdoll" or not model then return end
	local clone = model:Clone();
	clone.Parent = model;
	
	clone.Name = model.Name .. "Clone";
end)
