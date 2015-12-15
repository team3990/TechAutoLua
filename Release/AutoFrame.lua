LoadTxt = require( "LoadTxt")
config = require("config")
ModuleLoader = require("ModuleLoader")
Tools = require ("Tools")


DoneWithLinearCommands = false
currentmodule = nil
paralleltasks = {}

usedmodules   = {}

index = 0

MoteurVitesse    = 0.0
MoteurRotation   = 0.0
MoteurBras       = 0.0
MoteurRamasseur  = 0.0
distance         = 0.0
autocounter      = 0


RamasseurSwitch  = false
EstFini          = false

Commands = ModuleLoader.ReadCommands() --tridimensional array
-- Array of a list of action blocks
-- Action blocks are list of commands.  First action is a linear command.  Other actions are parallel. 
-- Actions are arrays with a module name parsed args.
print(#Commands)
function IsUsed(modulename)

	for i = 1, #usedmodules do
		if(usedmodules[i] == modulename) then return true end
	
	end
	return false

end

function RemoveName(modulename)
	
	for i = 1, #usedmodules do
		if(usedmodules[i] == modulename) then usedmodules[i] = nil; break end
	end
	
end



function update()
	print("-----------------------------------")
	if(not DoneWithLinearCommands) then
		-- Let's play with linear commands
		if(currentmodule == nil) then
			index = index + 1
			commandtable = Commands[index]
		
			if commandtable == nil then
				DoneWithLinearCommands = true
				return
			end
			
			command = commandtable[1]

			print("command "..index)

			currentmodule = ModuleLoader.InitModule(command)
			if(currentmodule.name ~= nil) then
				print("Command name: "..currentmodule.name)
			end
			
			for i = 2, #commandtable do
				Tools.append(paralleltasks, InitModule(commandtable[i]))
				name = paralleltasks[#paralleltasks].name
				if(name ~= nil) then
					print("***Name of parallel command: "..name)		
					
				end
				
			end

		
		elseif (ModuleLoader.CommandIsDone(currentmodule)) then
			RemoveName(currentmodule.rawname)
			currentmodule = nil -- Whack teh module!
			update()
			
			
		else
			ModuleLoader.CommandBody(currentmodule)
			
			
		end
	else
		print("Waiting for parallel commands to end...")
	end
		
	for i = #paralleltasks, 1, -1 do
		local parallelmodule = paralleltasks[i]
		--print("NOM: "..parallelmodule.name)
		if(ModuleLoader.CommandIsDone(parallelmodule)) then 
			RemoveName(parallelmodule.rawname);
			print("KIEL "..parallelmodule.rawname)
			paralleltasks[i] = nil; 
			
			
			ModuleLoader.CommandBody(parallelmodule)
		end
	end
	
	if(DoneWithLinearCommands and #paralleltasks == 0) then
		EstFini = true
	end
	
		

		

end


