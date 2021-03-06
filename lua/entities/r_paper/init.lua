AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/props/cs_militia/newspaperstack01.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then phys:Wake() end
	
	self.health = R_PRINT.CFG.paperHealth
	self.iterationsGranted = R_PRINT.CFG.howManyIterationsGranted
end

function ENT:OnTakeDamage(data)
	local dmg = data:GetDamage()

	self.health = self.health - dmg
	
	if (self.health <= 0) then self:Remove() end
end