local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local Players = game:GetService("Players")
local RagdollService, StateManager

local PlayerService = {}
PlayerService.__index = PlayerService
PlayerService.AllPlayers = {}

function PlayerService.SetupPlayer(player)
	PlayerService.new(player)
	player.CharacterAdded:Connect(function(character)
		PlayerService.GetPlayer(player.UserId).State:SetState(StateManager.States.IDLE)
		PlayerService.SetCharacter(player, character)
	end)
end

function PlayerService.__init()
	RagdollService, StateManager = ModuleHandler:Get("Ragdoll"), ModuleHandler:Get("StateManager")
end

function PlayerService.__start()
	for _, player in pairs(Players:GetPlayers()) do
		PlayerService.SetupPlayer(player)
	end

	Players.PlayerAdded:Connect(function(player)
		PlayerService.SetupPlayer(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		PlayerService.AllPlayers[player] = nil
	end)
end

function PlayerService.new(player)
	local self = setmetatable({}, PlayerService)

	self.State = StateManager.new()
	self.Attributes = {}
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
