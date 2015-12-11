LoadTxt    = require "LoadTxt"
currentmodule = nil
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

function ReadActions()

	local file = io.open("Test.txt", "r")
	while 1 do
		local str = file:read("*line")
		if str == nil then break end

		Actions[#Actions+1] = LoadTxt.parse(str);
		print(str)
	end
		
end

function InitModule(action)
	Argtable = {}
	for i = 2, #action do Argtable[#Argtable + 1] = action[i] end
	currentmodule = dofile ((action[1])..".lua")

	currentmodule.init(Argtable)

	
end



function update()
	
	if(currentmodule == nil) then
		index = index + 1
		action = Actions[index]
		print("---------------------")
		if action == nil then
			print("Fin. Lua out!")
			EstFini = true
			return
		end
		

		print("action "..index)

		InitModule(action)
		if(currentmodule.name ~= nil) then
			print("Nom de l'action: "..currentmodule.name)
		end
	
		
	
	elseif (currentmodule.isdone()) then
	
		currentmodule = nil -- Supprime le module de la vie.
		
	else
		currentmodule.body()
		
		
	end
	
		

		

end

ReadActions()

