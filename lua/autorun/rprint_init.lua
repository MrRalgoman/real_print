R_PRINT = R_PRINT || {}
R_PRINT.CFG = R_PRINT.CFG || {}

AddCSLuaFile("config.lua")

if (SERVER) then
	include("config.lua")
else
	include("config.lua")
end