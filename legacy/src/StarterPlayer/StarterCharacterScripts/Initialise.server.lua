local ragdollSystem = require(game.ReplicatedStorage.Modules.RagdollSystem);
local model = script.Parent

ragdollSystem:SetupModel(model);

local state = Instance.new("StringValue");
state.Name = "State"
state.Value = "Default";
state.Parent = model;

print(state.Parent);

