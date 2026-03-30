local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local Players = game:GetService("Players")
local RagdollService, StateManager

local PlayerService = {}
PlayerService.__index = PlayerService
PlayerService.AllPlayers = {}

function PlayerService.__init()
	RagdollService, StateManager = ModuleHandler:Get("Ragdoll"), ModuleHandler:Get("StateManager")
end

function PlayerService.__start()
	for _, player in pairs(Players:GetPlayers()) do
		PlayerService.new(player)
	end

	Players.PlayerAdded:Connect(function(player)
		PlayerService.new(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		PlayerService.AllPlayers[player] = nil
	end)
end

function PlayerService.new(player)
	local self = setmetatable({}, PlayerService)

	self.State = StateManager.new()
	self.Attributes = {}

	print("player added", player)

	PlayerService.AllPlayers[player] = self

	self.SetCharacter(player, player.Character or player.CharacterAdded:Wait())

	return self
end

function PlayerService.GetPlayer(player)
	return PlayerService.AllPlayers[player]
end

function PlayerService.SetCharacter(player, character)
	RagdollService:SetupModel(character)

	local self = PlayerService.GetPlayer(player)
	if not self then
		warn(`player {player.Name} not found in player manager!`)
		return
	end

	self.Character = character
	self.Character.Humanoid.Died:Connect(function()
		print(`{player.Name} has seen the light`)
		self.State:SetState(StateManager.States.DEAD, self.Character)
	end)
end

return PlayerService
