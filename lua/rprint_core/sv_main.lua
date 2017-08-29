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