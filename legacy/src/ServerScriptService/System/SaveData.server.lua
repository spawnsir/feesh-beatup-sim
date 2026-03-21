local DataStoreService = game:GetService("DataStoreService");
local Players = game:GetService("Players");

local stats = require(script.Parent.StatsManager);
local pserverData = DataStoreService:GetDataStore("PrivateServerData");

function saveServerData(key:string, data:any)
	local save, e = pcall(function() 
		pserverData:SetAsync(key, data);
	end)
	
	if not save then
		warn("could not save data for private server id: " .. key .. "" .. e);
	else
		print("data successfully saved for server id: " .. key);
	end
end

function loadServerData(key:string)
	local data = nil;
	local load, e = pcall(function()
		data = pserverData:GetAsync(key);
	end)
	
	if not load then
		warn("could not load dat a for sevrerid :" .. key);
	end
	
	return data
end

if game.PrivateServerId and game.PrivateServerId ~= "" and game.PrivateServerOwnerId then -- check for private server and NOT reserved server
	local key = tostring(game.PrivateServerId);
	local key2 = tostring(game.PrivateServerOwnerId);
	
	local data = loadServerData(key);
	if data then
		print("date laaoded for:" .. key);
	else
		print("no existing data fodund for :  ".. key);
		data = loadServerData(key2);
	end
	
	for stat, value in pairs(data) do
		stats.SetStat(stat, value);
	end
	
	game:BindToClose(function()                --  SAVE THE DATA WHEN THE GAME IS CLOSSSEDD RAAAAHHHHHH!!!!!!!!!!!!!!!!!!!!!
		print("saving the deta");
		local saveData = stats;
		
		saveData(key, saveData);
		saveData(key2, saveData)
		print("save initiated");
	end)
else
	print("this is not a private server!!!!!!!!!!!!!!!!!!!");
end