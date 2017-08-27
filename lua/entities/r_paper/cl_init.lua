include('shared.lua')

function ENT:Draw()
	self:DrawModel()

	local myPos = self:GetPos()

	if (myPos:DistToSqr(EyePos()) <= 384 * 384) then
		local eye = LocalPlayer():EyeAngles()
		local Pos = self:LocalToWorld(self:OBBCenter()) + Vector(0, -1, 50)
		local Ang = Angle(0, eye.y - 90, 90)
		cam.Start3D2D(Pos + Vector(0, 0, -30 + math.sin(CurTime()) * 2), Ang, 0.2)
			draw.SimpleText(R_PRINT.CFG.howManyIterationsGranted, "rprint_paperAmountDisplay", 0, -10, Color(255, 255, 255), TEXT_ALIGN_CENTER, 0, 1, Color(0, 0, 0, 255))
		cam.End3D2D()
	end
end