R_PRINT = R_PRINT || {}
R_PRINT.CFG = R_PRINT.CFG || {}

AddCSLuaFile("config.lua")
AddCSLuaFile("rprint_core/cl_fonts.lua")
AddCSLuaFile("rprint_core/cl_main.lua")


if (SERVER) then
	include("config.lua")
	include("rprint_core/sv_main.lua")
else
	include("config.lua")
	include("rprint_core/cl_fonts.lua")
	include("rprint_core/cl_main.lua")
end