util.AddNetworkString("rprint_updateClient")
util.AddNetworkString("rprint_pauseTimer")
util.AddNetworkString("rprint_resumeTimer")

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

function R_PRINT.ExtModelInit(ply, prevEnt)
	prevEnt:Remove()
	local mdl = ents.Create("r_extinguisher")
	if (!IsValid(mdl)) then return end

	local pos = ply:EyePos()
	local ang = ply:GetAngles()
	mdl:SetPos(pos + ang:Forward() * 40 + ang:Up() * - 15)
	mdl:Spawn()
end

local previousEnt

hook.Add("OnEntityCreated", "remove_extinguisher_swep", function(ent)
	if (!IsValid(previousEnt)) then previousEnt = ent return end

	if (previousEnt:GetClass() == "r_extinguisher") then
		if (ent:GetClass() != "spawned_weapon") then return end

		ent:Remove()
	end

	previousEnt = ent
end)

hook.Add("EntityRemoved", "rprint_entRemoved", function(ent)
	if (ent:GetClass() != "r_printer") then return end

	ent:StopSound("rprint_iteration")
	local id1 = "rprint_" .. ent:EntIndex()
	local id2 = "extinguish_" .. ent:EntIndex()
	if (timer.Exists(id1)) then timer.Remove(id1) end
	if (timer.Exists(id2)) then timer.Remove(id2) end
end)