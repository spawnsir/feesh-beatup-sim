local userId = 5139606675;
local description = game:GetService("Players"):GetHumanoidDescriptionFromUserIdAsync(userId);

script.Parent.Humanoid:BuildRigFromAttachments();
script.Parent.Humanoid:ApplyDescriptionAsync(description);
