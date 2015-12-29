Tools = require("Tools")
m = {}

local containers = {}

function PushContainer(name)
	containers[name:lower()] = {}
end

function PushModule(name, command)
	if(command[1][1]) then
		Tools.foreach(command, function(item) PushModule(name, item) end)-- Do recursion until you get a {module, args} array
		
	else
		result = InitModule(command)
		if(result and result ~= {}) then
			print("Initialized "..result.rawname)
			Tools.append(containers[name:lower()], result)
		end
	end
	

end

function update()
	print(string.rep("=", 50))
	print("Updating. ")
	local modulelist = {}
	for name, container in pairs(containers) do
		print(string.rep("*", 10))
		print("In module container: "..name)
		for i = #container, 1, -1 do
			command = container[i]
			name = command.rawname
			
			print((#container - i + 1)..". Updating "..name..". ")
		
			CommandBody(command)
			if(CommandIsDone(command)) then
				print("Command "..name.." is complete!!!")
				container[i] = nil
			
			end
		end
		
	end
	
	
end

function GetLength(name)
	return #containers[name:lower()]
	
end

function CommandIsDone(_module)
	state, result = Tools.safecall(_module.isdone, string.format("Bork when calling isdone in module %s", _module.rawname))
	if(not state) then 
	
		return true 
	

	end --... Oh shit
	
	if(result) then
			Tools.safecall(_module.whendone, string.format("Bork when calling whendone in module %s", _module.rawname))
			return true
	end
		
	return false			
end

function CommandBody(_module)
	if(_module == nil) then return end
	state, result = Tools.safecall(_module.body, string.format("Bork when calling body in module %s", _module.rawname))
	if(not state) then _module.isdone = (function() return true end) end -- Let's end this
end

function InitModule(command)
	for name, container in pairs(containers) do	
		
		for i = 1, #container do
			if container[i].parent == command[1] then
				print("Module already in use")
				return
			end
		end
	end
	args = Tools.tableindex(command, 2, 0)
	local newmodule = Tools.deepcopy(command[1])
	newmodule.parent  = command[1]
	
	success, foo = Tools.safecall(function() newmodule.init(args) end, "*** Module init threw an exception")

	
	if(not success) then
		-- Oh dear
		return 
	end
	return newmodule

end

m.PushContainer = PushContainer
m.PushModule    = PushModule
m.update        = update
m.GetLength     = GetLength

return m
