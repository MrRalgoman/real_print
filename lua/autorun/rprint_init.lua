R_PRINT = {}
R_PRINT.CFG = {}

AddCSLuaFile("rprint_config.lua")
AddCSLuaFile("rprint_core/cl_fonts.lua")
AddCSLuaFile("rprint_core/cl_main.lua")

if (SERVER) then
	resource.AddFile("materials/models/oldbill/moneyprinter1.vmt")
	resource.AddFile("models/oldbill/ricoh_printer.mdl")

	include("rprint_config.lua")
	include("rprint_core/sv_main.lua")
end

if (CLIENT) then
	include("rprint_config.lua")	
	include("rprint_core/cl_fonts.lua")
	include("rprint_core/cl_main.lua")
end