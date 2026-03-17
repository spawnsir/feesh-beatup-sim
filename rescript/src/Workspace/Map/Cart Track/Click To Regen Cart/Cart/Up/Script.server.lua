function chng()
	script.Parent.Parent.Speed.Value = script.Parent.Parent.Speed.Value + 3
	script.Parent.BrickColor = BrickColor.new(21)
	wait(0.2)
	script.Parent.BrickColor = BrickColor.new(0)
end

script.Parent.Click.MouseClick:connect(chng)
