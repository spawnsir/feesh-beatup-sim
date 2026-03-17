local MarketplaceService = game:GetService("MarketplaceService")

local MusicService = {}
MusicService.Folder = nil
MusicService.BGMPlaylist = nil
MusicService.CurrentIndex = nil
MusicService.SoundInfo = nil

function MusicService.__init()
	MusicService.Folder = game.ReplicatedStorage:WaitForChild("Assets").Sound
	MusicService.BGMPlaylist = MusicService.Folder.Music.BGM:GetChildren()
	MusicService.CurrentIndex = math.random(1, #MusicService.BGMPlaylist)

	MusicService:Play()
end

function MusicService:Play()
	local sound = self.BGMPlaylist[MusicService.CurrentIndex]

	if sound then
		local name = sound.Name
		sound:Play()

		local success, info = pcall(function()
			return MarketplaceService:GetProductInfoAsync(string.match(sound.SoundId, "%d+"), Enum.InfoType.Asset)
		end)
		if success then
			self.SoundInfo = info
			name = info.Name
		end

		print("playing " .. name)

		sound.Ended:Wait()
		self:Next()
	end
end

function MusicService:PlaySFX(name, parent: Instance?, random: boolean?)
	random = random or true

	local sound = self.Folder.SFX:WaitForChild(name)

	if sound then
		if sound:IsA("Folder") and random then
			sound = sound:GetChildren()[math.random(1, #sound:GetChildren())]
		end

		if not sound:IsA("Sound") then
			return
		end

		sound = sound:Clone()

		if parent then
			sound.Parent = parent
		end

		sound:Play()

		sound.Ended:Wait()
		sound:Destroy()
	end
end

function MusicService:Next()
	local newIndex = self.CurrentIndex + 1
	if newIndex > #self.BGMPlaylist then
		newIndex = 1
	end
	self.CurrentIndex = newIndex

	self:Play()
end

function MusicService:Prev()
	local newIndex = self.CurrentIndex - 1
	if newIndex < 1 then
		newIndex = #self.BGMPlaylist
	end
	self.CurrentIndex = newIndex

	self:Play()
end

function MusicService:PlayByIndex(index)
	if index > #self.BGMPlaylist then
		index = #self.BGMPlaylist
	end

	local sound = self.BGMPlaylist[index]

	if sound then
		self.CurrentIndex = 1
		sound.Parent = game.Workspace
		sound:Play()

		self:Play()
	end
end

return MusicService
