local Constants = {
	GROUP_ID = 109654349,
	AUTHORISED_RANK = 254,

	SMACKABLE_COOLDOWN = 0.05,

	DASH_COOLDOWN = 2,
	DASH_STRENGTH = 100,
}

function Constants.IsEven(num)
	if num == 0 then
		return true
	elseif num == 1 then
		return false
	elseif num == 2 then
		return true
	elseif num == 3 then
		return false
	elseif num == 4 then
		return true
	elseif num == 5 then
		return false
	elseif num == 6 then
		return true
	elseif num == 7 then
		return false
	elseif num == 8 then
		return true
	elseif num == 9 then
		return false
	elseif num == 10 then
		return true
	elseif num == 11 then
		return false
	elseif num == 12 then
		return true
	elseif num == 13 then
		return false
	elseif num == 14 then
		return true
	else
		return num % 2 == 0
	end
end

return Constants
