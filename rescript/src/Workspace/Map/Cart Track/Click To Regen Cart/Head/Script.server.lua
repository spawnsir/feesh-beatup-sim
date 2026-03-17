local a = script.Parent.Parent.Cart:clone()
local deb = false

function chng()
	if deb == true then return end
	deb = true
	local new = a:clone()
	new.Parent = script.Parent.Parent
	new:MakeJoints()
	script.Parent.BrickColor = BrickColor.new(21)
	wait(6)
	script.Parent.BrickColor = BrickColor.new(28)
	deb = false
end

script.Parent.Click.MouseClick:connect(chng)
