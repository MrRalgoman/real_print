AddCSLuaFile("swep_construction.lua")
include("swep_construction.lua")

SWEP.ViewModelBoneMods 		= {
	["ValveBiped.Grenade_body"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements				= {
	["models/props/cs_office/fire_extinguisher.mdl"] = { type = "Model", model = "models/props/cs_office/fire_extinguisher.mdl", bone = "ValveBiped.Grenade_body", rel = "", pos = Vector(-3.419, 0.118, 6.488), angle = Angle(-153.792, 71.091, 22.656), size = Vector(0.61, 0.61, 0.61), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements 				= {
	["models/props/cs_office/fire_extinguisher.mdl"] = { type = "Model", model = "models/props/cs_office/fire_extinguisher.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.904, -1.81, 8.515), angle = Angle(180, 65.72, 14.918), size = Vector(0.755, 0.755, 0.755), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.PrintName				= "Extinguisher"
SWEP.Author					= "MrRalgoman"
SWEP.Instructions			= "Left or Right click to extinguish a printer fire!"
SWEP.Spawnable 				= true
SWEP.AdminOnly				= true

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.Slot					= 1
SWEP.SlotPos				= 2
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= true
SWEP.ViewModel				= "models/weapons/v_grenade.mdl"
SWEP.WorldModel				= "models/weapons/w_grenade.mdl"
SWEP.ViewModelFOV 			= 70.35175879397
SWEP.ViewModelFlip 			= false

SWEP.HoldType 				= "slam"
SWEP.UseHands 				= false
SWEP.ShowViewModel 			= true
SWEP.ShowWorldModel 		= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 			= Vector(2.759, 0, 0.759)
SWEP.IronSightsAng 			= Vector(0, 0, 0)

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
	self:ShootWater()
end

function SWEP:Think()
	self.thinkOwner = self:GetOwner()
end

if (SERVER) then
	function SWEP:OnDrop()
		R_PRINT.ExtModelInit(self.thinkOwner, self)
	end
end

local hitCount = 0

function SWEP:ShootWater()
	local owner = self:GetOwner()
	local traceData = owner:GetEyeTrace()
	local ent = traceData.Entity

	if (ent:IsOnFire() && traceData.StartPos:Distance(ent:GetPos()) <= 150) then
		hitCount = hitCount + 1
	
		if (SERVER) then
			timer.Simple(0.01, function()
				local effectData = EffectData()
				effectData:SetOrigin(ent:GetPos())
				effectData:SetScale(15)
				util.Effect("watersplash", effectData)
			end)
		end

		if (hitCount >= R_PRINT.CFG.extinguishHits) then
			hitCount = 0
			if (SERVER) then
				ent:Extinguish()
				R_PRINT.ResumeTimer(ent:EntIndex())
				timer.Destroy("extinguish_" .. ent:EntIndex())
			end
		end
	elseif (traceData.StartPos:Distance(ent:GetPos()) >= 150 && ent:IsOnFire()) then
		R_PRINT.Notify("You are too far away!")
	end
end