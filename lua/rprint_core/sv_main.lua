util.AddNetworkString("rprint_setIteration")
util.AddNetworkString("rprint_pauseTimer")
util.AddNetworkString("rprint_resumeTimer")

sound.Add({
	name = "rprint_iteration",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 60,
	pitch = {95, 100},
	sound = "ambient/levels/labs/equipment_printer_loop1.wav"
})

sound.Add({
	name = "rprint_explosion",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = {95, 100},
	sound = "ambient/explosions/explode_" .. math.random(1, 4) .. ".wav"
})

function R_PRINT.PauseTimer(id)
	timer.Pause("rprint_" .. id)
	net.Start("rprint_pauseTimer")
	net.WriteInt(id, 32)
	net.Send(player.GetAll())
end

function R_PRINT.ResumeTimer(id)
	timer.UnPause("rprint_" .. id)
	net.Start("rprint_resumeTimer")
	net.WriteInt(id, 32)
	net.Send(player.GetAll())
end

local entClass = FindMetaTable("Entity")

function entClass:rprint_Explode()
	if (!self:IsValid()) then return end
	util.BlastDamage(self, self, self:GetPos(), 200, 75)
	self:EmitSound("rprint_explosion")
	self:Remove()
end

function entClass:rprint_HandleFireChance()
	local iteration = self.rprint_reps
	local explodeChance = math.random(100, 1)

	if (R_PRINT.CFG.lowChanceOfFire[iteration]) then
		local percent = R_PRINT.CFG.lowChancePercent
		if (explodeChance <= percent) then
			self:Ignite(R_PRINT.CFG.extinguishTime + 1)
			self:StopSound("rprint_iteration")
			R_PRINT.PauseTimer(self:EntIndex())
			timer.Create("extinguish_" .. self:EntIndex(), R_PRINT.CFG.extinguishTime, 1, function()
				if (self:IsOnFire()) then self:rprint_Explode() else R_PRINT.ResumeTimer(self:EntIndex()) end
			end)
		end
	elseif (R_PRINT.CFG.moderateChanceOfFire[iteration]) then
		local percent = R_PRINT.CFG.moderateChancePercent
		if (explodeChance <= percent) then
			self:Ignite(R_PRINT.CFG.extinguishTime + 1)
			self:StopSound("rprint_iteration")
			R_PRINT.PauseTimer(self:EntIndex())
			timer.Create("extinguish_" .. self:EntIndex(), R_PRINT.CFG.extinguishTime, 1, function()
				if (self:IsOnFire()) then self:rprint_Explode() else R_PRINT.ResumeTimer(self:EntIndex()) end
			end)
		end
	elseif (R_PRINT.CFG.highChanceOfFire[iteration]) then
		local percent = R_PRINT.CFG.highChancePercent
		if (explodeChance <= percent) then
			self:Ignite(R_PRINT.CFG.extinguishTime + 1)
			self:StopSound("rprint_iteration")
			R_PRINT.PauseTimer(self:EntIndex())
			timer.Create("extinguish_" .. self:EntIndex(), R_PRINT.CFG.extinguishTime, 1, function()
				if (self:IsOnFire()) then self:rprint_Explode() else R_PRINT.ResumeTimer(self:EntIndex()) end
			end)
		end
	else 
		return
	end
end

function entClass:rprint_AddMoney(amount)
	if (!self.rprint_money) then
		self.rprint_money = 0
	end
	self.rprint_money = self.rprint_money + amount
	self:SetNWInt("rprint_Money", self.rprint_money)
end

function entClass:rprint_GetMoney()
	return self.rprint_money || 0
end

function entClass:rprint_AddReps(id, reps)
	local time = R_PRINT.CFG.TimePerIteration

	if (!timer.Exists("rprint_" .. id)) then
		timer.Create("rprint_" .. id, time, reps, function()
			self:EmitSound("rprint_iteration")
			timer.Simple(R_PRINT.CFG.TimePerIteration, function() self:StopSound("rprint_iteration") end)
			self:rprint_AddMoney(math.random(R_PRINT.CFG.highAmount, R_PRINT.CFG.lowAmount))
			self:rprint_setIteration(timer.RepsLeft("rprint_" .. id))
			self:rprint_HandleFireChance()
		end)
		self:rprint_setIteration(reps)
		return
	end

	local repsLeft = timer.RepsLeft("rprint_" .. id)
	local newReps = repsLeft + reps
	if (newReps > R_PRINT.CFG.NumberOfIterations) then newReps = 10 end
	timer.Destroy("rprint_" .. id)
	timer.Create("rprint_" .. id, time, newReps, function()
		self:EmitSound("rprint_iteration")
		timer.Simple(R_PRINT.CFG.TimePerIteration, function() self:StopSound("rprint_iteration") end)
		self:rprint_AddMoney(math.random(R_PRINT.CFG.highAmount, R_PRINT.CFG.lowAmount))
		self:rprint_setIteration(timer.RepsLeft("rprint_" .. id))
		self:rprint_HandleFireChance()
	end)

	self:rprint_setIteration(newReps)
end

function entClass:rprint_setIteration(iteration)
	self.rprint_reps = iteration
	net.Start("rprint_setIteration")
	net.WriteEntity(self)
	net.WriteInt(self:EntIndex(), 32)
	net.WriteInt(iteration, 32)
	net.Send(player.GetAll())
end

hook.Add("EntityTakeDamage", "rprint_paperHealth", function(ent, data)
	if (ent:GetClass() == "r_paper") then
		local damage = data:GetDamage()
		ent.rprint_health = ent.rprint_health - damage

		if (ent.rprint_health <= 0) then
			ent:Remove()
		end
	elseif (ent:GetClass() == "r_printer") then
		local damage = data:GetDamage()
		ent.rprint_health = ent.rprint_health - damage

		if (ent.rprint_health <= 0) then
			ent:Ignite(2)
			timer.Simple(1, function()
				ent:rprint_Explode()
			end)
		end
	end
end)

hook.Add("EntityRemoved", "rprint_removeTimers", function(ent)
	if (ent:GetClass() == "r_printer") then
		if (timer.Exists("rprint_" .. ent:EntIndex())) then
			timer.Destroy("rprint_" .. ent:EntIndex())
			ent:StopSound("rprint_iteration")
		end
	end
end)