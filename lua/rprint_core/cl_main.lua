local entClass = FindMetaTable("Entity")

function entClass:rprint_GetMoney()
	self.rprint_money = self:GetNWInt("rprint_Money")
	return self.rprint_money
end

function entClass:rprint_determineBarColor()
	local iteration = self.rprint_reps

	if (R_PRINT.CFG.lowChanceOfFire[iteration]) then
		return {[1] = Color(0, 255, 0), [2] = Color(75, 255, 75)}
	elseif (R_PRINT.CFG.moderateChanceOfFire[iteration]) then
		return {[1] = Color(255, 255, 51), [2] = Color(255, 255, 153)}
	elseif (R_PRINT.CFG.highChanceOfFire[iteration]) then
		return {[1] = Color(255, 0, 0), [2] = Color(255, 75, 75)}
	else 
		return {[1] = Color(0, 255, 0), [2] = Color(75, 255, 75)}
	end
end