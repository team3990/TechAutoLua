LoadTxt    = require "LoadTxt"
currentmodule = nil
index = 0

MoteurVitesse    = 0.0
MoteurRotation   = 0.0
MoteurBras       = 0.0
MoteurRamasseur  = 0.0
distance         = 0.0


RamasseurSwitch  = false
EstFini          = false

Actions = {}

function ReadActions()

	local file = io.open("Test.txt", "r")
	while 1 do
		local str = file:read("*line")
		if str == nil then break end

		Actions[#Actions+1] = LoadTxt.parse(str);
	end
		
end

function InitModule(action)
	Argtable = {}
	for i = 2, #action do Argtable[#Argtable + 1] = action[i] end
	currentmodule = dofile ((action[1])..".lua")
	currentmodule.init(Argtable)
	
end



function update()
	--print("In update")

	if(currentmodule == nil) then
		index = index + 1
		action = Actions[index]
		if action == nil then
			EstFini = true
			return
		end
		
		InitModule(action)
		
	
	elseif (currentmodule.isdone()) then
		currentmodule = nil -- Supprime le module de la vie.
		
	else
		currentmodule.body()
		print("Distance parcourue: "..distance);
		
	end
		
		

		

end

ReadActions()


update()
update()
