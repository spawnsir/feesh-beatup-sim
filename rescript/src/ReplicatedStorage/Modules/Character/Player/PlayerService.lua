local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local Players = game:GetService("Players")
local RagdollService, StateManager, BaseCharacter

local PlayerService = {}
PlayerService.__index = PlayerService
PlayerService.AllPlayers = {}

function PlayerService.SetupPlayer(player)
	player.CharacterAdded:Connect(function(character)
		PlayerService.new(character)
		PlayerService.SetCharacter(character, character)
		PlayerService.GetPlayer(character).State:SetState(StateManager.States.IDLE)
	end)
end

function PlayerService.__init()
	RagdollService, StateManager, BaseCharacter =
		ModuleHandler:Get("RagdollService"), ModuleHandler:Get("StateManager"), ModuleHandler:Get("BaseCharacter")
end

function PlayerService.__start()
	PlayerService = setmetatable(PlayerService, BaseCharacter)
end

function PlayerService.new(player)
	print(player)
	local self = setmetatable(BaseCharacter.new(player), PlayerService)

	self.Debounces = {}

	print("player added", player)

	PlayerService.AllPlayers[player] = self

	self.SetCharacter(player, player)

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
	self.Character.Humanoid.Died:Once(function()
		self.State:SetState(StateManager.States.DEAD, self.Character)
	end)
end

function PlayerService:IsOnCooldown(input)
	return self.Debounces[input]
end

return PlayerService
