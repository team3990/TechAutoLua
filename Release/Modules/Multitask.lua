m = {}
LoadTxt      = dofile "LoadTxt.lua"
ModuleLoader = dofile "ModuleLoader.lua"

m.name = "Multitask "

modules = {}
	
-- Good ole functions
function m.init(newactions)
	name = ""
	for i = 1, #newactions do
		modules[#modules + 1] = ModuleLoader.InitModule(LoadTxt.parse(newactions[i]));
		name = name .. modules[#modules].name .. " "
	end
	
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
	return (#modules == 0)

end

function m.whendone() end
	



return m
