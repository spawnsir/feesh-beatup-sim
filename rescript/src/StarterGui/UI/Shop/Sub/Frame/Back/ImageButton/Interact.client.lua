local b = script.Parent;

b.MouseButton1Click:Connect(function()
	script.Parent.Parent.Parent.Visible = false;
	script.Parent.Parent.Parent.Parent.Parent.Select.Frame.Visible = true;
	
	local upgrades = script.Parent.Parent.Parent.Upgrades;
	for _, v in pairs(upgrades:GetDescendants()) do
		if not v:IsA("Frame") then continue end
		v.Visible = false;
	end
end)
