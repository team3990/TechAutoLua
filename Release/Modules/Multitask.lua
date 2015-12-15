m = {}
LoadTxt      = require "LoadTxt"
ModuleLoader = require("ModuleLoader")
Tools        = require("Tools")

m.name = "Multitask "

local modules = {}

-- Good ole functions
function m.init(newactions)
	name = ""
	for i = 1, #newactions do
		Tools.append(modules, ModuleLoader.InitModule(LoadTxt.parse(newactions[i])));
		name = name .. modules[#modules].name .. " "
	end
	
	print(modules[2].body == m.body)
	print(name)

end

function m.body()
	for i = 1, #modules do
		ModuleLoader.CommandBody(modules[i])
	end
end

function m.isdone()
	for i = #modules, 1, -1 do
		
		if ModuleLoader.CommandIsDone(modules[i]) then
			RemoveName(modules[i].rawname)
			modules[i] = nil -- Bye bye, once again
			
		end
	
	end
	print("TO RETURN: "..#modules)
	return (#modules == 0)

end

function m.whendone() end
	



return m
