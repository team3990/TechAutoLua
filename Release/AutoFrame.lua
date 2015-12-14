LoadTxt      = dofile "LoadTxt.lua"
config       = dofile "config.lua"
ModuleLoader = dofile "ModuleLoader.lua"


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

Commands = {}

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



function ReadCommands()
	local file = io.open(config.F_instrucfile, "r")
	commandtable = {}
	linenumber = 1
	while 1 do
		local str = file:read("*line")
		
		if str == nil then
			break -- EOF
		end
		
		str = string.gsub(str, config.STR_CommentChar..".*", "") -- Strip comment line
		
		
		if (str:sub(1, 1) == config.STR_ParallelToken) then
			-- Parallel
			if #commandtable > 0 then 
				result = LoadTxt.parse(string.sub(str, 2, -1))

			else
				print("Can't run parallel commands like linear commands!")
			end
		
		elseif (str:sub(1, 1) == config.STR_MultitaskToken) then
			-- Create a multitask object and put stuff in it
			_index = 1
			moduletable = {"Multitask"} -- That's a module like any other
			subcommand = ""
			str = str:sub(2) -- Remove the token at the beginning
			while 1 do
				_, _index, subcommand = string.find(str, config.STR_CommandRegex) -- Find first occurence of (...)
				if(not subcommand) then break end -- Stahpings
				str = str:sub(_index)
				moduletable[#moduletable + 1] = subcommand:sub(2, -2)
				

			end
			if(#commandtable > 0) then Commands[#Commands + 1] = commandtable; commandtable = {} end
			commandtable[1] = moduletable

			
		

		else 
			if(#commandtable > 0) then Commands[#Commands + 1] = commandtable; commandtable = {} end
			commandtable[1] = LoadTxt.parse(str);
			
		
		end
		print("LEN: "..#Commands)
		
	end
	if(#commandtable > 0) then Commands[#Commands + 1] = commandtable; commandtable = {} end
		
end



function InitModule(command)
	if(command == nil) then return end
	if(#command == 0)  then return end
	if(not IsUsed(command[1])) then -- if a module of the same name is still running, manually block it
		print("INIT: "..command[1])
		usedmodules[#usedmodules + 1] = command[1]
		Argtable = {}
		for i = 2, #command do 
			Argtable[#Argtable + 1] = command[i]

		end
		print("CREATING")
		local newmodule = dofile (string.format(config.F_moduleformat, command[1]))
		print("CREATED")
		
		if(newmodule.ArgTemplates) then
			if(not ModuleLoader.AnalyseArgs(Argtable, newmodule.ArgTemplates)) then
					print("*** Bad arguments: skipping.")
					return
			end
			
		end

		success, result = pcall(function() newmodule.init(Argtable) end)
		print("CALLD")
		
		if(not success) then
			-- Oh dear

			print("*** Sounds like the module is broke, skipping. ")
			print(result) -- stderr
			return 
		end
		newmodule.rawname = command[1]
		return newmodule
	
	end
	
	print("Module "..command[1].." already running...")
	return nil

	
end



function update()
	if(currentmodule == nil) then
		index = index + 1
		commandtable = Commands[index]

		
		print("---------------------")
		if commandtable == nil then
			print("Fin. Lua out!")
			EstFini = true
			return
		end
		
		command = commandtable[1]

		print("command "..index)

		currentmodule = InitModule(command)
		if(currentmodule.name ~= nil) then
			print("Command name: "..currentmodule.name)
		end
		
		for i = 2, #commandtable do
			paralleltasks[#paralleltasks+1] = InitModule(commandtable[i])
			
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
		currentmodule.body()
		
		
	end
	
	for i = #paralleltasks, 1, -1 do
		local parallelmodule = paralleltasks[i]
		--print("NOM: "..parallelmodule.name)
		if(ModuleLoader.CommandIsDone(parallelmodule)) then 
			RemoveName(parallelmodule.rawname);
			paralleltasks[i] = nil; 
			
		else 
	
			ModuleLoader.CommandBody(parallelmodule)
		end
	end
	
		

		

end

ReadCommands()

