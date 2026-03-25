local GuiManager = {}

local player = game.Players.LocalPlayer
local playerGui = nil

function GuiManager.__init()
	playerGui = player:WaitForChild("PlayerGui", 300)
	for _, gui in pairs(playerGui:GetChildren()) do
		print(gui.Name)
	end
end

function GuiManager:GetGUI(name: string)
	local gui = playerGui:WaitForChild(name)
	if not gui then
		warn(`GUI with name {name} not found!`)
		return
	end

	return gui
end

function GuiManager:ToggleGUI(name: string, toggle: boolean)
	local gui = self.GetGUI(name)
	if not gui then
		return
	end

	gui.Enabled = toggle
end

function GuiManager.OpenGUIOnly(name: string)
	GuiManager.CloseAll()
	GuiManager:ToggleGUI(name, true)
end

function GuiManager.CloseAll()
	for _, gui in pairs(playerGui:GetChildren()) do
		if not gui:IsA("ScreenGui") then
			continue
		end
		gui.Enabled = false
	end
end

function GuiManager:GetFrame(guiName: string, frameName: string)
	local gui = self:GetGUI(guiName)
	if not gui then
		return
	end

	local frame = gui:FindFirstChild(frameName)
	if not frame then
		warn(`Frame with name {frameName} not found in GUI {guiName}!`)
		return
	end

	return frame
end

function GuiManager:ToggleFrame(guiName: string, frameName: string, toggle: boolean)
	local frame = self:GetFrame(guiName, frameName)
	if not frame then
		return
	end

	frame.Visible = toggle
end

return GuiManager
