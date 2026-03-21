local b = script.Parent

b.Activated:Connect(function()
	local upgrades = script.Parent.Parent.Parent.Parent.Parent.Sub.Frame.Upgrades;
	script.Parent.Parent.Parent.Visible = false;
	
	script.Parent.Parent.Parent.Parent.Parent.Sub.Frame.Visible = true;
	for _, v in pairs(upgrades:GetDescendants()) do
		if not v:IsA("Frame") or v.Parent.Name == "Template" then continue end
		v.Visible = true;
	end
end)
