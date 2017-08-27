include('shared.lua')

local white 		= Color(255, 255, 255)
local green 		= Color(0, 255, 0)
local greenShade 	= Color(75, 255, 75)
local grey 			= Color(85, 85, 85)
local darkGrey		= Color(65, 65, 65)

local w = 108
local h = 25

local shit = w / R_PRINT.CFG.TimePerIteration

net.Receive("rprint_setIteration", function()
	local ent = net.ReadEntity()
	local id = net.ReadInt(32)
	local reps = net.ReadInt(32)
	ent.rprint_money = net.ReadInt(32)

	ent.rprint_reps = reps

	if (!timer.Exists("rprint_" .. id)) then
		timer.Create("rprint_" .. id, R_PRINT.CFG.TimePerIteration, reps, function() 
			if (reps == 0) then timer.Destroy("rprint_" .. id) print("destroyed fgt") end
		end)
		return
	end

	timer.Destroy("rprint_" .. id)
	timer.Create("rprint_" .. id, R_PRINT.CFG.TimePerIteration, reps, function()
		if (reps == 0) then timer.Destroy("rprint_" .. id) print("destroyed fgt") end
	end)
end)

function ENT:Draw()
	self:DrawModel()

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
		cam.Start3D2D(pos + ang:Up() * 12.2 + ang:Right() * -23.4 + ang:Forward() * -15.4, ang, 0.1)
			surface.SetDrawColor(grey)
			surface.DrawRect(-1, -1, w + 2, h + 2)

			surface.SetDrawColor(green)
			surface.DrawRect(1, 1, timeLeft, h - 2)
			surface.SetDrawColor(greenShade)
			surface.DrawRect(1, 1, timeLeft, h/5)
		cam.End3D2D()

		cam.Start3D2D(pos + ang:Up() * 16.3 + ang:Right() * -19.4 + ang:Forward() * 12, ang, 0.1)
			draw.SimpleTextOutlined(self.rprint_reps || 0, "rprint_repsDisplay", 0, 0, white, 1, 1, 1, Color(0, 0, 0))
		cam.End3D2D()

		ang:RotateAroundAxis(ang:Forward(), -90)

		cam.Start3D2D(pos + ang:Up() * 24.05 + ang:Right() * 13.05 + ang:Forward() * -3.4, ang, 0.1)
			surface.SetDrawColor(darkGrey)
			surface.DrawRect(0, 0, 88.5, 30)
			
			draw.SimpleTextOutlined(DarkRP.formatMoney(self:GetMoney()), "rprint_moneyDisplay", 88.5/2, 30/2, white, 1, 1, 1, Color(0, 0, 0))
		cam.End3D2D()
	end
end