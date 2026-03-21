local stats = {
	Money = 0,
	Upgrades = {}
}

function stats:GetStat(stat:string)
	if stats then
		return stats[stat];
	end
	
	return nil
end

function stats:SetStat(stat:string, value:any)
	if stats then
		if type(stats[stat]) == "table" then 
			stats[stat][value[1]] = value[2];
			print("set " .. value[1] .. " in " .. stat .. " to " .. value[2]);
		else 
			stats[stat] = value; 
			print("set " .. stat .. " to " .. value);
		end 
	else
		print("stats is nil???????");
	end
end

function stats:IncrementStat(stat:string, value:any)
	if stats then
		stats[stat] = stats[stat] + value;
		print("added " .. value .. " to " .. stat);
	else
		print("stats is nil???????");
	end
end

return stats;
