local playlist = game.ReplicatedStorage.Sound.Music:WaitForChild("BGM");

local songs = playlist:GetChildren();
local currentIndex = math.random(1, #songs);

function nextSong()
	local sound = songs[currentIndex];
	
	if sound then
		print("playing " .. sound.Name);
		sound:Play();
		sound.Ended:Wait();
		
		local newIndex = math.random(1, #songs);
		if newIndex > currentIndex then
			newIndex += 1;
		end
		if newIndex > #songs then
			newIndex = 0;
		end
		currentIndex = newIndex;
	end
	
	nextSong()
end

function playByIndex(index)
	if index > #songs then 
		index = #songs;
	end
	
	local sound = songs[index];
	
	if sound then
		currentIndex = 1;
		sound.Parent = game.Workspace;
		sound:Play();
		
		nextSong();
	end
end

nextSong();