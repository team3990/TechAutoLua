m = {}
require("LoadTxt")

m.name = "Multitask "

modules = {}
	
-- Good ole functions
function m.init(newactions)
	name = ""
	for i = 1, #newactions do
		modules[#modules + 1] = InitModule(LoadTxt.parse(newactions[i]));
		name = name .. modules[#modules].name .. " "
	end
	
	print(name)
	
	


end

function m.body()
	for i = 1, #modules do
		modules[i].body()
	end
end

function m.isdone()
	for i = #modules, 1, -1 do	
		if modules[i].isdone() then
			modules[i].whendone()
			RemoveName(modules[i].rawname)
			modules[i] = nil -- Bye bye, once again
		
			
		end
	
	end
	return (#modules == 0)

end

function m.whendone() end
	



return m
