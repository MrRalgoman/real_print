local canMessage = true

function R_PRINT.Notify(message, type)
	if (R_PRINT.CFG.notificationType == 0) then
		if (canMessage) then
			canMessage = false
			notification.AddLegacy(message, type || 1, 3)
			timer.Simple(2, function() canMessage = true end)
		end
	else
		if (canMessage) then
			canMessage = false
			chat.AddText("[R_Print] " .. message)
			timer.Simple(2, function() canMessage = true end)
		end
	end
end