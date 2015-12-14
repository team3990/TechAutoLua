LoadTxt    = require "LoadTxt"
config     = require "config"

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

Actions = {}

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

function ReadActions()
	local file = io.open(config.F_instrucfile, "r")
	actiontable = {}
	while 1 do
		local str = file:read("*line")
		
		if str == nil then 
			break 
		
		
		elseif (str:sub(1, 1) == config.STR_ParallelToken) then
			-- Parallel
			if #actiontable > 0 then 
				actiontable[#actiontable + 1] = LoadTxt.parse(string.sub(str, 2, -1))

			end
		
		elseif (str:sub(1, 1) == config.STR_MultitaskToken) then
			-- Create a multitask object and put stuff in it
			_index = 1
			moduletable = {"Multitask"}
			subaction = ""
			str = str:sub(2)
			while 1 do
				_, _index, subaction = string.find(str, config.STR_ActionRegex)
				if(not subaction) then break end
				str = str:sub(_index)
				moduletable[#moduletable + 1] = subaction:sub(2, -2)
				

			end
			if(#actiontable > 0) then Actions[#Actions + 1] = actiontable; actiontable = {} end
			actiontable[1] = moduletable

			
		

		else 
			if(#actiontable > 0) then Actions[#Actions + 1] = actiontable; actiontable = {} end
			actiontable[1] = LoadTxt.parse(str);
		
		end
		
	end
	if(#actiontable > 0) then Actions[#Actions + 1] = actiontable; actiontable = {} end
		
end



function InitModule(action)
	if(not IsUsed(action[1])) then
		print("INIT: "..action[1])
		usedmodules[#usedmodules + 1] = action[1]
		Argtable = {}
		for i = 2, #action do 
			Argtable[#Argtable + 1] = action[i]

		end
		local newmodule = dofile (string.format(config.F_moduleformat, action[1]))

		newmodule.init(Argtable)
		newmodule.rawname = action[1]
		return newmodule
	
	end
	
	print("Module "..action[1].." deja utilise...")
	return nil

	
end



function update()
	if(currentmodule == nil) then
		index = index + 1
		actiontable = Actions[index]

		
		print("---------------------")
		if actiontable == nil then
			print("Fin. Lua out!")
			EstFini = true
			return
		end
		
		action = actiontable[1]

		print("action "..index)

		currentmodule = InitModule(action)
		if(currentmodule.name ~= nil) then
			print("Nom de l'action: "..currentmodule.name)
		end
		
		for i = 2, #actiontable do
			paralleltasks[#paralleltasks+1] = InitModule(actiontable[i])
			
			name = paralleltasks[#paralleltasks].name
			if(name ~= nil) then
				print("***Nom de l'action parallele: "..name)		
				
			end
			
		end

		
	
		
	
	elseif (currentmodule.isdone()) then
		currentmodule.whendone()
		RemoveName(currentmodule.rawname)
		currentmodule = nil -- Supprime le module de la vie.
		update()
		
		
	else
		currentmodule.body()
		
		
	end
	
	for i = #paralleltasks, 1, -1 do
		local parallelmodule = paralleltasks[i]
		--print("NOM: "..parallelmodule.name)
		if(parallelmodule.isdone()) then 
			paralleltasks[i].whendone()
			paralleltasks[i] = nil; 
			print("Module name: "..parallelmodule.rawname)
			RemoveName(parallelmodule.rawname);
		else 
	
			parallelmodule.body()
		end
	end
	
		

		

end

ReadActions()

