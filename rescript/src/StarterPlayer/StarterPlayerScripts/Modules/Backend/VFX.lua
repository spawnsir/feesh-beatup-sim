local TweenService = game:GetService("TweenService");

local VFXService = {}

function VFXService.HighlightModel(model, tweenInfo, fillTransparency:number?, outlineTransparency:number?, fill:Color3?, outline:Color3?)
	
	local highlight = Instance.new("Highlight");
	
	highlight.FillColor = fill or Color3.new(1, 0, 0);
	highlight.OutlineColor = outline or Color3.new(1, 1, 1);
	
	highlight.Parent = model;
	highlight.FillTransparency = fillTransparency or 0;
	highlight.OutlineTransparency = outlineTransparency or 0;
	
	local tween = TweenService:Create(highlight, tweenInfo, {FillTransparency = 1, OutlineTransparency = 1});
	tween:Play()
	
	task.spawn(function()
		tween.Completed:Wait();
		highlight:Destroy();
	end)
	
end

return VFXService
