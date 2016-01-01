Tools = require("Tools")
config = require("config")
m = {}

local containers = {}

function PushContainer(name)
	containers[name:lower()] = {}
end

function PushModule(name, command)
	if(command[1] and not command[1].rawname) then
	
		Tools.foreach(command, function(item) PushModule(name, item) end)
		
	else
		if(#command == 0) then return end
		local success, result = Tools.safecall(function() return InitModule(command) end, "Error when calling init:")
		if(not success) then return end
		
		if(result and result ~= {}) then
			print("Initialized "..result.rawname)
			Tools.append(containers[name:lower()], result)
		end
	end
	

end

function update()
	print(config.STR_TextSeparator)
	print("Updating. ")
	local modulelist = {}
	for name, container in pairs(containers) do
		print(config.STR_SubSeparator)
		print("In module container: "..name)
		for i = #container, 1, -1 do
			local command = container[i]
			local name = command.rawname
			
			print((#container - i + 1)..". Updating "..name..". ")
		
			if(not CommandBody(command) or CommandIsDone(command)) then
				print("Command "..name.." is complete!!!")
				container[i] = nil
			
			end
		end
		
	end
	
	
end

function GetContainer(name)
	return containers[name:lower()]
	
end

function CommandIsDone(_module)
	local state, result = Tools.safecall(_module.isdone, string.format("Bork when calling isdone in module %s", _module.rawname))
	if(not state) then 
		result = true
	end
	
	if(result) then
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



function InitModule(command)
	for name, container in pairs(containers) do	
		for i = 1, #container do
			if container[i].parent == command[1] then
				error({msg = "Module already in use"})
			end
		end
	end
	args = Tools.tableindex(command, 2, 0)
	local newmodule = Tools.deepcopy(command[1]) -- Clone the base module 
	
	newmodule.parent  = command[1]
	
	success, foo = Tools.safecall(function() newmodule.init(args) end, "Module init threw an exception")

	
	if(not success) then
		error({msg = foo})
	end
	
	return newmodule

end

m.PushContainer = PushContainer
m.PushModule    = PushModule
m.update        = update
m.GetContainer  = GetContainer

return m
