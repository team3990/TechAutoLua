print("Bleh")
config           = require("config")
ModuleLoader     = require("ModuleLoader")
ModuleContainer  = require("ModuleContainer")
Tools            = require ("Tools")
print("Bleh")
dofile("stringops.lua")
z = "aaa"

index = 0

MoteurVitesse    = 0.0
MoteurRotation   = 0.0
MoteurBras       = 0.0
MoteurRamasseur  = 0.0
distance         = 0.0
autocounter      = 0

RamasseurSwitch  = false
EstFini          = false

result, Commands = pcall(ModuleLoader.ReadCommands)
if(not result) then EstFini = true end


MainCommands = ModuleContainer.InitContainer()
Parallels    = ModuleContainer.InitContainer()

function _update()
	print(config.STR_TextSeparator)
	print("Loop #"..autocounter)
	if(#MainCommands == 0) then
		index = index + 1
		commandtable = Commands[index]
		if commandtable == nil then
			print("Fin. Lua out!")
			EstFini = true
			return
		end
		
		MainCommands:PushCommand(commandtable[1])
		Parallels:PushCommand(Tools.tableindex(commandtable, 2, 0))
	
	else
		print("Parallel commands: ")
		Parallels:update()
		print(config.STR_SubSeparator)
		print("Normal commands: ")
		MainCommands:update()
		
	end
	
end

function update()
	x, y = pcall(_update)
	if not x then io.stdout:write(y) end
end

