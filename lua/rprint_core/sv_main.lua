util.AddNetworkString("rprint_setIteration")

local entClass = FindMetaTable("Entity")

function entClass:rprint_AddMoney(amount)
	self.rprint_money = amount + self.rprint_money || 0
	self:SetNWInt("rprint_Money", self.rprint_money)
end

function entClass:rprint_GetMoney()
	return self.rprint_money || 0
end

function entClass:rprint_AddReps(id, reps)
	local time = R_PRINT.CFG.TimePerIteration

	if (!timer.Exists("rprint_" .. id)) then
		timer.Create("rprint_" .. id, time, reps, function()
			self:rprint_AddMoney(math.random(R_PRINT.CFG.highAmount, R_PRINT.CFG.lowAmount))
			self:rprint_setIteration(timer.RepsLeft("rprint_" .. id))
		end)
		self:rprint_setIteration(reps)
		return
	end

	local repsLeft = timer.RepsLeft("rprint_" .. id)
	local newReps = repsLeft + reps
	if (newReps > R_PRINT.CFG.NumberOfIterations) then newReps = 10 end
	timer.Destroy("rprint_" .. id)
	timer.Create("rprint_" .. id, time, newReps, function()
		self:rprint_AddMoney(math.random(R_PRINT.CFG.highAmount, R_PRINT.CFG.lowAmount))
		self:rprint_setIteration(timer.RepsLeft("rprint_" .. id))
	end)

	self:rprint_setIteration(newReps)
end

function entClass:rprint_setIteration(iteration)
	net.Start("rprint_setIteration")
	net.WriteEntity(self)
	net.WriteInt(self:EntIndex(), 32)
	net.WriteInt(iteration, 32)
	net.Send(player.GetAll())
end