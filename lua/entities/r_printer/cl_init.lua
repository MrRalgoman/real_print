include('shared.lua')

local white 		= Color(255, 255, 255)
local green 		= Color(0, 255, 0)
local greenShade 	= Color(75, 255, 75)
local grey 			= Color(85, 85, 85)
local darkGrey		= Color(65, 65, 65)

local w = 108
local h = 25

function ENT:Draw()
	self:DrawModel()

	local timeLeft
	if (timer.Exists("your_mother")) then
		timeLeft = timer.TimeLeft("your_mother") * 10.8
		print(timeLeft)
		print(timer.RepsLeft("your_mother"))
		timeLeft = timeLeft - 2
		if (timeLeft < 0) then
			timeLeft = 0
		end
	else
		timeLeft = 0
	end

	local repsLeft
	if (timer.Exists("your_mother")) then
		repsLeft = timer.RepsLeft("your_mother")
	else
		repsLeft = 0
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
			draw.SimpleText(repsLeft, "rprint_repsDisplay", 0, 0, white, 1, 1)
		cam.End3D2D()

		ang:RotateAroundAxis(ang:Forward(), -90)

		cam.Start3D2D(pos + ang:Up() * 24.05 + ang:Right() * 13.05 + ang:Forward() * -3.4, ang, 0.1)
			surface.SetDrawColor(darkGrey)
			surface.DrawRect(0, 0, 88.5, 30)
			
			draw.SimpleText(DarkRP.formatMoney(self:GetMoney()), "rprint_moneyDisplay", 88.5/2, 30/2, white, 1, 1)
		cam.End3D2D()
	end
end

-- test command remove later
concommand.Add("testShit", function()
	timer.Create("your_mother", R_PRINT.CFG.TimePerIteration, 5, function() end)
end)