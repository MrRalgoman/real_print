-- [[ Notification type, 1 for chat message or 0 for darkrp notification ]] --
R_PRINT.CFG.notificationType 				= 0

-- [[ Printer and paper entity health ]] --
R_PRINT.CFG.printerHealth					= 200
R_PRINT.CFG.paperHealth						= 100

-- [[ How many iterations should the printer go through ]] --
R_PRINT.CFG.NumberOfIterations				= 10

-- [[ How much time per iteration ]] --
R_PRINT.CFG.TimePerIteration				= 1

-- [[ How much money should be granted per iteration (random number is chosen between the two values set) ]] --
R_PRINT.CFG.lowAmount						= 200
R_PRINT.CFG.highAmount						= 300

-- [[ How many iterations should one single paper entity grant ]] --
R_PRINT.CFG.howManyIterationsGranted		= 10

-- [[ Should the printer have a chance of catching fire? (if false then you can ignore the settings below) ]] --
R_PRINT.CFG.catchFire						= true

-- [[ How long should the printer be on fire before it blows up ]] --
R_PRINT.CFG.extinguishTime 					= 5

-- [[ How many hits from the extinguisher should it take to extinguish a printer fire? ]] --
R_PRINT.CFG.extinguishHits					= 5

-- [[ ----- Low ----- ]] --

-- [[ At what iterations should there be a low chance of catching fire? ]] --
-- [[ The progress bar will show green at this level ]] --
R_PRINT.CFG.lowChanceOfFire	= {
	[5]										= true,
	[6]										= true,
	[7]										= true,
	[8]										= true,
	[9]										= true,
	[10]									= true
}
-- [[ The chance of catching fire, the number is a percent out of 100 ]] --
R_PRINT.CFG.lowChancePercent				= 100

-- [[ ----- Moderate ----- ]] --

-- [[ At what iterations should there be a chance of catching fire? ]] --
-- [[ The progress bar will show yellow at this level ]] --
R_PRINT.CFG.moderateChanceOfFire = {
	[3]										= true,
	[4]										= true
}
-- [[ The chance of catching fire, the number is a percent out of 100 ]] --
R_PRINT.CFG.moderateChancePercent			= 100

-- [[ ----- High ----- ]] --

-- [[ At what iterations should there be a high chance of catching fire? ]] --
-- [[ The progress bar will show red at this level ]] --
R_PRINT.CFG.highChanceOfFire = {
	[0]										= true,
	[1]										= true,
	[2]										= true
}
-- [[ The chance of catching fire, the number is a percent out of 100 ]] --
R_PRINT.CFG.highChancePercent				= 100