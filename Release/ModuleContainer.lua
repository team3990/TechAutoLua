Tools = require("Tools")
config = require("config")
m = {}

UsedModules = {}

local containerclass = {}


function m.InitContainer()

	return Tools.deepcopy(containerclass)

end


function containerclass.PushCommand(container, command)
	if(command and command[1] and not command[1].rawname) then
		Tools.foreach(command, function(item) container:PushCommand(item) end)
		
	elseif command then
		if(#command == 0) then return end
		local success, result = Tools.safecall(function() return InitModule(command) end, "Error when calling init:")
		if(not success) then return end
		
		if(result and result ~= {}) then
			print("Initialized "..result.rawname)
			container[#container + 1] = result

		end
	end
	

end

function InitModule(command)
	for i = 1, #UsedModules do	
		if(UsedModules[i] == command[1]) then
			error({msg = "Module already in use"}) -- To prevent undefined behavior
		end
	end
	
	Tools.append(UsedModules, command[1])
	
	args = Tools.tableindex(command, 2, 0)
	local newmodule = Tools.deepcopy(command[1]) -- Clone the base module 
	
	newmodule.parent  = command[1]
	success, foo = Tools.safecall(function() newmodule.init(args) end, "Module init threw an exception")

	
	if(not success) then
		error({msg = foo})
	end
	
	return newmodule

end


function containerclass.update(container)
	for i = #container, 1, -1 do
		local command = container[i]
		local name = command.rawname
		
		print((#container - i + 1)..". Updating "..name..". ")
	
		if(not CommandBody(command) or CommandIsDone(command)) then
			print("Command "..name.." is complete!!!")
			container[i] = nil -- Module is kill
		
		end
		
		
	end	
	
	Tools.remove(container, nil)
	
	
	
	
end

function CommandIsDone(_module)
	local state, result = Tools.safecall(_module.isdone, string.format("Bork when calling isdone in module %s", _module.rawname))
	if(not state) then 
		result = true
	end
	
	if(result) then
			Tools.remove(UsedModules, _module)
			Tools.safecall(_module.whendone, string.format("Bork when calling whendone in module %s", _module.rawname))
			return true
	end
		
	return false			
end

function CommandBody(_module)
	if(_module == nil) then return end
	local state, result = Tools.safecall(_module.body, string.format("Bork when calling body in module %s", _module.rawname))
	
	return state
end

return m
