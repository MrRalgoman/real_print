local entClass = FindMetaTable("Entity")

function entClass:AddMoney(amount)
	self.rprint_money = self.rprint_money || 0 + amount
end

function entClass:GetMoney()
	return self.rprint_money || 0
end

function R_PRINT.AddReps(id, reps)
	if (!timer.Exists(id)) then return end
	local repsLeft = timer.RepsLeft(id)
	timer.Destroy(id)
	timer.Create(id, R_PRINT.CFG.TimePerIteration, repsLeft + reps, function() return end)
end