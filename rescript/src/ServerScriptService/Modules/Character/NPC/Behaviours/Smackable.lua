-- feeshiest
local ModuleHandler = require(game:GetService("ReplicatedStorage").ModuleHandler)

local NetworkService, Data, GameSettings, PlayerService, Constants

local SmackBehaviour = {}
SmackBehaviour.__index = SmackBehaviour

function SmackBehaviour.__init()
	NetworkService, Data, GameSettings, PlayerService, Constants =
		ModuleHandler:Get("Network"),
		ModuleHandler:Get("Data"),
		ModuleHandler:Get("GameSettings"),
		ModuleHandler:Get("PlayerService"),
		ModuleHandler:Get("Constants")
end

function SmackBehaviour.new(parent)
	local self = setmetatable({}, SmackBehaviour)

	self.Parent = parent
	self.Character = parent.Character
	self.Debounce = false
	self.Cooldown = Constants.SMACKABLE_COOLDOWN

	local hitbox = self:CreateHitbox()
	self.ClickDetector = hitbox:FindFirstChild("ClickDetector") or Instance.new("ClickDetector")
	self.ClickDetector.Parent = hitbox

	self.ClickDetector.MouseClick:Connect(function(player)
		self:OnClick(player)
	end)

	return self
end

function SmackBehaviour:CreateHitbox()
	print(self.Character)
	if not self.Character then
		return
	end

	if self.Character:FindFirstChild("Hitbox") then
		return self.Character.Hitbox
	end

	local hitbox = Instance.new("Part")
	hitbox.Name = "Hitbox"
	hitbox.Parent = self.Character

	hitbox.Size = Vector3.new(5, 7, 4)
	hitbox.CFrame = self.Character:GetPrimaryPartCFrame()
	hitbox.Color = Color3.new(1, 0, 0)
	hitbox.Transparency = 1

	hitbox.Massless = true
	hitbox.CanCollide = false
	hitbox.CanTouch = false
	hitbox.AudioCanCollide = false

	local weld = Instance.new("WeldConstraint")
	weld.Parent = hitbox
	weld.Part0 = hitbox
	weld.Part1 = self.Character.Torso

	return hitbox
end

function SmackBehaviour:OnClick(player)
	player = PlayerService.GetPlayer(player.Character)
	if self.Debounce or player.State.CurrentState == "Dead" then
		return
	end

	self.Debounce = true
	NetworkService:Fire(nil, "Smack", self.Character)

	if self.Parent.Attributes["Dropper"] then
		Data:SetDataValue("Cash", Data.Variables.Cash + 1 * GameSettings.Multipliers.Cash)
	end

	local hrp = self.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		local lv = Instance.new("LinearVelocity")
		local a = hrp:FindFirstChild("RootAttachment") or hrp:FindFirstChild("Attachment") or Instance.new("Attachment")

		lv.Parent = hrp
		lv.MaxForce = 10000
		lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
		lv.RelativeTo = Enum.ActuatorRelativeTo.World
		lv.Attachment0 = a
		lv.VectorVelocity = Vector3.new(math.random(-5, 5), 50, math.random(-5, 5))

		game.Debris:AddItem(lv, 0.05)
	end

	task.delay(self.Cooldown, function()
		self.Debounce = false
	end)

	self.Parent.State:SetState("Ragdoll", self.Character)
end

return SmackBehaviour
