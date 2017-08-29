include('shared.lua')

local white 		= Color(255, 255, 255)
local green 		= Color(0, 255, 0)
local greenShade 	= Color(75, 255, 75)
local grey 			= Color(85, 85, 85)
local darkGrey		= Color(65, 65, 65)

local w = 210
local h = 33

function ENT:IsRunning()
	return self:GetNWBool("rprint_running")
end

function ENT:GetRep()
	return self:GetNWInt("rprint_rep", 0)
end

function ENT:GetMoney()
	return self:GetNWInt("rprint_money")
end

function ENT:InitPrint()
	local reps = R_PRINT.CFG.howManyIterationsGranted
	local time = R_PRINT.CFG.TimePerIteration
	local id = "rprint_" .. self:EntIndex()

	timer.Create(id, time, reps, function() return end)
end

function ENT:AddRep(amount)
	local id = "rprint_" .. self:EntIndex()
	local reps = amount + timer.RepsLeft(id) || 0
	local time = R_PRINT.CFG.TimePerIteration

	if (reps < 0) then self.running = false return end
	if (reps > R_PRINT.CFG.NumberOfIterations) then reps = R_PRINT.CFG.NumberOfIterations end

	timer.Remove(id)
	timer.Create(id, time, reps, function() return end)
end

function ENT:DetermineBarColor()
	local iteration = self:GetRep()
	print(iteration)

	if (R_PRINT.CFG.lowChanceOfFire[iteration]) then
		return {[1] = Color(0, 255, 0), [2] = Color(75, 255, 75)}
	elseif (R_PRINT.CFG.moderateChanceOfFire[iteration]) then
		return {[1] = Color(255, 255, 51), [2] = Color(255, 255, 153)}
	elseif (R_PRINT.CFG.highChanceOfFire[iteration]) then
		return {[1] = Color(255, 0, 0), [2] = Color(255, 75, 75)}
	else 
		return {[1] = Color(0, 255, 0), [2] = Color(75, 255, 75)}
	end
end

net.Receive("rprint_updateClient", function()
	local ent = net.ReadEntity()
	if (!ent:IsRunning()) then print("Initing Print") ent:InitPrint() return end
	ent:AddRep(R_PRINT.CFG.howManyIterationsGranted)
end)

net.Receive("rprint_pauseTimer", function()
	local id = net.ReadInt(32)
	if (!timer.Exists("rprint_" .. id)) then return end
	timer.Pause("rprint_" .. id)
end)

net.Receive("rprint_resumeTimer", function()
	local id = net.ReadInt(32)
	if (!timer.Exists("rprint_" .. id)) then return end
	timer.UnPause("rprint_" .. id)
end)

function ENT:Draw()
	self:DrawModel()

	local shit = w / R_PRINT.CFG.TimePerIteration
	local id = self:EntIndex()

	local timeLeft
	if (timer.Exists("rprint_" .. id)) then
		timeLeft = timer.TimeLeft("rprint_" .. id) * shit
		timeLeft = timeLeft - 2
		if (timeLeft < 0) then
			timeLeft = 0
		end
	else
		timeLeft = 0
	end

	local pos = self:GetPos()
	local ang = self:GetAngles()

	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), -90)

	if (pos:DistToSqr(EyePos()) <= 384 * 384) then
		cam.Start3D2D(pos + ang:Up() * 9.8 + ang:Right() * -31.3 + ang:Forward() * -10.5, ang, 0.1)
			surface.SetDrawColor(grey)
			surface.DrawRect(-1, -1, w + 2, h + 2)

			surface.SetDrawColor(self:DetermineBarColor()[1])
			surface.DrawRect(1, 1, timeLeft, h - 2)
			surface.SetDrawColor(self:DetermineBarColor()[2])
			surface.DrawRect(1, 1, timeLeft, h/5)
		cam.End3D2D()

		cam.Start3D2D(pos + ang:Up() * 9.8 + ang:Right() * -35 + ang:Forward() * 7.5, ang, 0.1)
			draw.SimpleTextOutlined(self:GetRep() || 0, "rprint_repsDisplay", 0, 0, white, 1, 1, 1, Color(0, 0, 0))
		cam.End3D2D()

		ang:RotateAroundAxis(ang:Forward(), -58)

		cam.Start3D2D(pos + ang:Up() * 39.6 + ang:Right() * -13.1 + ang:Forward() * -10.3, ang, 0.1)
			surface.SetDrawColor(darkGrey)
			surface.DrawRect(0, 0, 120, 24)
			
			draw.SimpleTextOutlined(DarkRP.formatMoney(self:GetMoney()), "rprint_moneyDisplay", 114/2, 25/2, white, 1, 1, 1, Color(0, 0, 0))
		cam.End3D2D()
	end
end