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
	
	self.iterationsGranted = R_PRINT.CFG.howManyIterationsGranted
end

function ENT:StartTouch(ent)
	local name = ent:GetClass()
	local id = ent:EntIndex()
	local amount = R_PRINT.CFG.howManyIterationsGranted

	if (name == "r_printer") then
		self:Remove()
		ent:rprint_AddReps(id, amount)
	end
end