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

hook.Add("EntityRemoved", "rprint_entRemoved", function(ent)
	if (ent:GetClass() != "r_printer") then return end

	local id1 = "rprint_" .. ent:EntIndex()
	local id2 = "extinguish_" .. ent:EntIndex()
	if (timer.Exists(id)) then timer.Remove(id) end
	if (timer.Exists(id2)) then timer.Remove(id2) end
end)