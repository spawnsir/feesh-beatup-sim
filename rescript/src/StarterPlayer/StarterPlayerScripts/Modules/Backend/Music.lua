local MarketplaceService = game:GetService("MarketplaceService")

local MusicService = {}
MusicService.Folder = nil
MusicService.BGMPlaylist = nil
MusicService.CurrentIndex = nil
MusicService.SoundInfo = nil

function MusicService.__init()
	MusicService.Folder = game:GetService("ReplicatedStorage"):WaitForChild("Assets").Sound
	MusicService.BGMPlaylist = MusicService.Folder.Music.BGM:GetChildren()
	MusicService.CurrentIndex = math.random(1, #MusicService.BGMPlaylist)

	MusicService:Play()
end

function MusicService:Play()
	local bgm = self.BGMPlaylist[MusicService.CurrentIndex]

	if bgm then
		local name = bgm.Name
		bgm:Play()

		local success, info = pcall(function()
			return MarketplaceService:GetProductInfoAsync(string.match(bgm.SoundId, "%d+"), Enum.InfoType.Asset)
		end)
		if success then
			self.SoundInfo = info
			name = info.Name
		end

		print("playing " .. name)

		bgm.Ended:Wait()
		self:Next()
	end
end

function MusicService:PlaySFX(name, parent: Instance?, clone: boolean?, random: boolean?)
	clone = clone or false
	random = random or true

	local oneshot = self.Folder.SFX:FindFirstChild(name) or (parent and parent:FindFirstChild(name))

	if oneshot then
		if oneshot:IsA("Folder") and random then
			oneshot = oneshot:GetChildren()[math.random(1, #oneshot:GetChildren())]
		end

		if not oneshot:IsA("Sound") then
			return
		end

		if clone then
			oneshot = oneshot:Clone()
		end

		local oldParent = oneshot.Parent

		if parent then
			oneshot.Parent = parent
		end

		print(`playing sfx: {name}`)
		oneshot:Play()

		oneshot.Ended:Wait()
		oneshot.Parent = oldParent

		if clone then
			oneshot:Destroy()
		end
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

	local bgm = self.BGMPlaylist[index]

	if bgm then
		self.CurrentIndex = 1
		bgm.Parent = game.Workspace
		bgm:Play()

		self:Play()
	end
end

return MusicService
