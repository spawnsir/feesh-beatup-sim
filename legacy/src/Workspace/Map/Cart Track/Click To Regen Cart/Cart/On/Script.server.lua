function chng()
	script.Parent.Parent.CarOn.Value = not script.Parent.Parent.CarOn.Value
	if script.Parent.Parent.CarOn.Value == false then
		script.Parent.BrickColor = BrickColor.new(21)
		else
		script.Parent.BrickColor = BrickColor.new(28)
	end
end

script.Parent.Click.MouseClick:connect(chng)
