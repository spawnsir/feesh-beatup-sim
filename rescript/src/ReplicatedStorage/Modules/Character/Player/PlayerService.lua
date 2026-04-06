local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local Players = game:GetService("Players")
local RagdollService, StateManager

local PlayerService = {}
PlayerService.__index = PlayerService
PlayerService.AllPlayers = {}

function PlayerService.SetupPlayer(player)
	PlayerService.new(player)
	player.CharacterAdded:Connect(function(character)
		PlayerService.SetCharacter(player, character)
		PlayerService.GetPlayer(player.UserId).State:SetState(StateManager.States.IDLE)
	end)
end

function PlayerService.__init()
	RagdollService, StateManager = ModuleHandler:Get("RagdollService"), ModuleHandler:Get("StateManager")
end

function PlayerService.new(player)
	local self = setmetatable({}, PlayerService)

	self.State = StateManager.new()
	self.Debounces = {}

	print("player added", player)

	PlayerService.AllPlayers[player] = self

	self.SetCharacter(player, player.Character or player.CharacterAdded:Wait())

	return self
end

function PlayerService.GetPlayer(id)
	local player = Players:GetPlayerByUserId(id)
	if not player then
		return
	end

	return PlayerService.AllPlayers[player]
end

function PlayerService.SetCharacter(player, character)
	RagdollService:SetupModel(character)

	local self = PlayerService.GetPlayer(player.UserId)
	if not self then
		warn(`player {player.Name} not found in player manager!`)
		return
	end

	self.Character = character
	self.Character.Humanoid.Died:Connect(function()
		self.State:SetState(StateManager.States.DEAD, self.Character)
	end)
end

function PlayerService:IsOnCooldown(input)
	return self.Debounces[input]
end

return PlayerService
