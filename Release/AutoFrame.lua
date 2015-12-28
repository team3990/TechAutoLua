config           = require("config")
ModuleLoader     = require("ModuleLoader")
ModuleContainer  = require("ModuleContainer")
Tools            = require ("Tools")

index = 0

MoteurVitesse    = 0.0
MoteurRotation   = 0.0
MoteurBras       = 0.0
MoteurRamasseur  = 0.0
distance         = 0.0
autocounter      = 0


RamasseurSwitch  = false
EstFini          = false

result, Commands = pcall(ModuleLoader.ReadCommands) --tridimensional array
print(result, Commands)
Tools.prettyprinter(Commands)
-- Array of a list of action blocks
-- Action blocks are list of commands.  First action is a linear command.  Other actions are parallel. 
-- Actions are arrays with a module name parsed args.

ModuleContainer.PushContainer("Commands")
ModuleContainer.PushContainer("Parallel")


function update()
	
	if(ModuleContainer.GetLength("Commands") == 0) then
		index = index + 1
		commandtable = Commands[index]
		
		print("---------------------")
		if commandtable == nil then
			print("Fin. Lua out!")
			EstFini = true
			return
		end

		if(commandtable[1][1][1] == nil) then
			ModuleContainer.PushModule("Commands", commandtable[1])
		
		else
			Tools.foreach(Tools.tableindex(commandtable[1], 1, 0), function(_table) ModuleContainer.PushModule("Commands", _table) end)
			
		end
		Tools.foreach(Tools.tableindex(commandtable, 2, 0), function(_table) ModuleContainer.PushModule("Parallel", _table) end)
		
	
	else
		ModuleContainer.update()
	end
	
end