local remote = game.ReplicatedStorage.Events.ComboEvent;

local counter = script.Parent.Counter;

local digits = {};
local text = {};

local originalPosition = counter.Position;

remote.OnClientEvent:Connect(function(combo)
	if combo <= 0 then
		script.Parent.Parent.Enabled = false;
		return
	end
	
	script.Parent.Parent.Enabled = true;
	
	local x = originalPosition.X;
	local y = originalPosition.Y;
	
	for _, v in pairs(text) do
		v:Destroy();
	end
	
	digits = tostring(combo):split("");
	
	for i = #digits, 1, -1 do
		text[i] = counter:Clone();
		text[i].Text = digits[i];
		text[i].Name = "Counter" ..tostring(i);
		text[i].Parent = script.Parent;
		text[i].Position = UDim2.new(x.Scale, x.Offset, y.Scale, y.Offset);
		
		x = UDim.new(x.Scale, x.Offset - text[i].TextBounds.X);
	end
	
	counter.Position = UDim2.new(x.Scale, x.Offset - 10, y.Scale, y.Offset);
end)
