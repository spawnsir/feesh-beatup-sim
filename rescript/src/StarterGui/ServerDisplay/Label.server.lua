local screenGui = script.Parent;
local textLabel = screenGui.Server;

local privateServer = game.PrivateServerId;

local id = privateServer;
local serverIdentifier = "Private";

if not game.PrivateServerOwnerId then
	serverIdentifier = "Reserved";
end

if not privateServer or privateServer == "" then
	id = game.JobId;
	serverIdentifier = "Public";
end

if not game.JobId or game.JobId == "" then
	id = "-";
	serverIdentifier = "Studio";
end

textLabel.Text = "Server: " ..id.. " (" ..serverIdentifier.. ")";
screenGui.Place.Text = "Place version: " ..game.PlaceVersion;
