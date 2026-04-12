local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local StateManager

local BaseCharacter = {}
BaseCharacter.__index = BaseCharacter

function BaseCharacter.__init()
	StateManager = ModuleHandler:Get("StateManager")
end

function BaseCharacter.new(model)
	local self = setmetatable({}, BaseCharacter)

	self.Character = model
	self.State = StateManager.new()
	self.Attributes = model:GetAttributes()

	return self
end

function BaseCharacter:MoveTo(pos)
	self.Character.Humanoid:MoveTo(pos)
end

function BaseCharacter:ApplyAvatarFromID(id, model)
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	local description = game:GetService("Players"):GetHumanoidDescriptionFromUserIdAsync(id)
	if not humanoid or not description then
		return
	end

	humanoid:ApplyDescription(description)
end

return BaseCharacter
