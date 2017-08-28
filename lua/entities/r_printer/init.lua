AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/pcmod/kopierer.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then phys:Wake() end

	self.rprint_health = R_PRINT.CFG.printerHealth
	self.rprint_canUse = true
end

function ENT:Use(activator, caller)
	if (self.rprint_money != 0 && self.rprint_canUse && !self:IsOnFire()) then
		self.rprint_canUse = false
		print(self.rprint_canUse)
		local pos = self:GetPos()
		local ang = self:GetAngles()

		DarkRP.createMoneyBag(pos + ang:Up() * 30 + ang:Forward() * 10, self.rprint_money)
		self:rprint_AddMoney(-self.rprint_money)

		self:EmitSound("buttons/button5.wav")
		timer.Simple(5, function() self.rprint_canUse = true end)
	end
end