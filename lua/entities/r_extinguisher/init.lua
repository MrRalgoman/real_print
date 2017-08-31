AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

-- This entity is used only to override the dropped model of the extinguisher swep
function ENT:Initialize()
	self:SetModel("models/props/cs_office/fire_extinguisher.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then phys:Wake() end
end

function ENT:Use(activator, ply)
	if (type(ply) != "Player") then return end
	ply:Give("swep_extinguisher")
	self:Remove()
end