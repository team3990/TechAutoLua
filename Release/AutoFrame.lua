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
if(not result) then EstFini = true end
-- Array of a list of action blocks
-- Action blocks are list of commands.  First action is a linear command.  Other actions are parallel. 
-- Actions are arrays with a module name parsed args.

ModuleContainer.PushContainer("Commands")
ModuleContainer.PushContainer("Parallel")


function _update()
	if(#ModuleContainer.GetContainer("Commands") == 0) then
		index = index + 1
		commandtable = Commands[index]
		
		print("---------------------")
		if commandtable == nil then
			print("Fin. Lua out!")
			EstFini = true
			logs:close()
			return
		end
		
		ModuleContainer.PushModule("Commands", commandtable[1])
		ModuleContainer.PushModule("Parallel", Tools.tableindex(commandtable, 2, 0))
	
	else
	
		ModuleContainer.update()
		print(distance)
	end
	
end

function update()
	x, y = pcall(_update)
	if not x then io.stdout:write(y) end
end

