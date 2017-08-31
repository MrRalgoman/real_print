AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

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

function ENT:Initialize()
	self:SetModel("models/oldbill/ricoh_printer.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then phys:Wake() end

	self.health = R_PRINT.CFG.printerHealth
	self.canUse = true
	self.running = true
	self.money = 0
	self.currentRep = 0
	self.uprightCD = false
end

local useCount = 0
local uprightCD = false
local canUse = true

function ENT:Use(activator, caller)
	if (self.money != 0 && !self:IsOnFire()) then
		canUse = false
		local pos = self:GetPos()
		local ang = self:GetAngles()

		local mny = DarkRP.createMoneyBag(pos + ang:Up() * 50 + ang:Forward() * 5, self.money)
		self:AddMoney(-self.money)

		self:EmitSound("buttons/button5.wav")
		timer.Simple(5, function() canUse = true end)
		return 
	end

	-- double press :D
	useCount = useCount + 1
	timer.Simple(0.2, function() useCount = 0 end)
	if (useCount == 2 && !uprightCD) then
		uprightCD = true
		local ang = self:GetAngles()
		local pos = self:GetPos() + Vector(0, 0, 1)

		self:SetAngles(Angle(0, 180 + caller:GetAngles().yaw, 0))
		self:SetPos(pos)

		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then phys:Wake() end

		timer.Simple(5, function() uprightCD = false end)
	elseif (uprightCD && useCount == 2) then
		DarkRP.notify(caller, 1, 3, "You can't do that yet!")
	end
end

function ENT:StartTouch(ent)
	local name = ent:GetClass()
	local id = "rprint_" .. self:EntIndex()
	local amount = R_PRINT.CFG.howManyIterationsGranted

	if (name == "r_paper") then
		ent:Remove()
		if (timer.Exists(id)) then self:AddRep(amount) else self:InitPrint() end
	end
end

function ENT:Explode()
	if (!self:IsValid()) then return end

	timer.Simple(0, function()
		local effectData = EffectData()
		effectData:SetOrigin(self:GetPos())
		effectData:SetScale(15)
		util.Effect("Explosion", effectData)
		util.BlastDamage(self, self, self:GetPos(), 200, 75)
		self:Remove()
	end)
end

function ENT:OnTakeDamage(data)
	local dmg = data:GetDamage()

	self.health = self.health - dmg
	
	if (self.health <= 0) then 
		self:Ignite(1) 
		timer.Simple(1, function() 
			self:Explode() 
		end) 
	end
end

function ENT:SetRunning(status)
	self.running = status
	self:SetNWBool("rprint_running", status)
end

function ENT:SetRep(rep)
	self.currentRep = rep
	self:SetNWInt("rprint_rep", rep)
end

function ENT:UpdateClient()
	net.Start("rprint_updateClient")
	net.WriteEntity(self)
	net.Send(player.GetAll())
end

function ENT:AddMoney(amount)
	self.money = self.money + amount
	self:SetNWInt("rprint_money", self.money)
end

function ENT:InitPrint()
	local reps = R_PRINT.CFG.howManyIterationsGranted
	local time = R_PRINT.CFG.TimePerIteration
	local id = "rprint_" .. self:EntIndex()
	self:SetRunning(true)
	self:SetRep(reps)

	self:EmitSound("rprint_iteration")
	timer.Create(id, time, reps, function()
		self:AddMoney(math.random(R_PRINT.CFG.highAmount, R_PRINT.CFG.lowAmount))
		self:StopSound("rprint_iteration")
		self:EmitSound("rprint_iteration")
		self:SetRep(timer.RepsLeft(id))
		self:HandleFireChance()

		if (self.currentRep == 0) then self:SetRunning(false) self:StopSound("rprint_iteration") end
	end)
	self:UpdateClient()
end

function ENT:AddRep(amount)
	local id = "rprint_" .. self:EntIndex()
	local reps = amount + timer.RepsLeft(id)
	local time = R_PRINT.CFG.TimePerIteration

	if (reps <= 0) then self:SetRunning(false) return end
	if (reps > R_PRINT.CFG.NumberOfIterations) then reps = R_PRINT.CFG.NumberOfIterations end
	-- if for w/e reason the tiemr doesnt exist or the printer isn't running kill the function
	if (!self.running || !timer.Exists(id)) then return end
	timer.Remove(id)

	self:SetRep(reps)
	self:StopSound("rprint_iteration")
	self:EmitSound("rprint_iteration")
	timer.Create(id, time, reps, function()
		self:AddMoney(math.random(R_PRINT.CFG.highAmount, R_PRINT.CFG.lowAmount))
		self:StopSound("rprint_iteration")
		self:EmitSound("rprint_iteration")
		self:SetRep(timer.RepsLeft(id))
		self:HandleFireChance()
		
		if (self.currentRep == 0) then self:SetRunning(false) self:StopSound("rprint_iteration") end
	end)
	self:UpdateClient()
end

function ENT:HandleFireChance()
	if (!R_PRINT.CFG.catchFire) then return end

	local id = "extinguish_" .. self:EntIndex()
	local rep = self.currentRep
	local percent
	local explodeChance = math.random(100, 1)

	if (R_PRINT.CFG.lowChanceOfFire[rep]) then
		percent = R_PRINT.CFG.lowChancePercent
	elseif(R_PRINT.CFG.moderateChanceOfFire[rep]) then
		percent = R_PRINT.CFG.moderateChancePercent
	elseif(R_PRINT.CFG.highChanceOfFire[rep]) then
		percent = R_PRINT.CFG.highChancePercent
	end

	if (!percent) then return end
	if (explodeChance <= percent) then
		self:Ignite(R_PRINT.CFG.extinguishTime + 1)
		self:StopSound("rprint_iteration")
		R_PRINT.PauseTimer(self:EntIndex())
		timer.Create(id, R_PRINT.CFG.extinguishTime, 1, function()
			if (self:IsOnFire()) then self:Explode() else R_PRINT.ResumeTimer(self:EntIndex()) end
		end)
	end
end