m = {}
LoadTxt      = require "LoadTxt"
ModuleLoader = require("ModuleLoader")
Tools        = require("Tools")

m.name = "Multitask "

local moomodules = {}
m.x = 0

-- Good ole functions
function m.init(newactions)
	name = ""
	for i = 1, #newactions do
		Tools.append(moomodules, ModuleLoader.InitModule(LoadTxt.parse(newactions[i])));
		name = name .. moomodules[#moomodules].name .. " "
	end
	
	print(moomodules[2].body == m.body)
	print(name)

end

function m.body()
	for i = 1, #moomodules do
		ModuleLoader.CommandBody(moomodules[i])
	end
end

function m.isdone()
	for i = #moomodules, 1, -1 do
		
		if ModuleLoader.CommandIsDone(moomodules[i]) then
			RemoveName(moomodules[i].rawname)
			moomodules[i] = nil -- Bye bye, once again
			
		end
	
	end
	print("TO RETURN: "..#moomodules)
	return (#moomodules == 0)

end

function m.whendone() end
	



return m
