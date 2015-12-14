m = {}

function m.AnalyseArgs(ArgTable, ArgTemplates)
	ArgTemplate = {}
	for i = 1, #ArgTable do
		ArgTemplate[#ArgTemplate + 1] = type(ArgTable[i])
		
	end
	
	for i = 1, #ArgTemplates do
		if(not CompareTemplates(ArgTemplate, ArgTemplates[i])) then
			return false
			
		end
	end
	return true
end

function CompareTemplates(template1, template2)
	if(template1 == nil or template2 == nil) then 
		return false
	end
	
	if(template1 == "*" or template2 == "*") then
		return true
	end
	
	if(#template1 ~= #template2) then
		return false
	end
	
	for i = 1, #template1 do
		templateoneitem = template1[i]
		templatetwoitem = template2[i]
		
		if(templateoneitem ~= "*" and templatetwoitem ~= "*" and templateoneitem ~= templatetwoitem) then
			return false
		end
	end
	return true
	
	
end

function safecall(func, errmsg)
	success, result = pcall(func)
	if(not success) then
		print(errmsg)
		print("EXC: "..result)
		return false
	
	else
		return true, result
		
	end
end

function m.CommandIsDone(_module)
		state, result = safecall(_module.isdone, string.format("Bork when calling isdone in module %s", _module.rawname))
		if(not state) then return true end
		
		if(result) then
				safecall(_module.whendone, string.format("Bork when calling whendone in module %s", _module.rawname))
				return true
		end
			
		return false			
end

function m.CommandBody(_module)
	if(_module == nil) then return end
	--print("In body ".._module.rawname)
	state, result = safecall(_module.body, string.format("Bork when calling body in module %s", _module.rawname))
	if(not state) then _module.isdone = (function() return true end) end -- Let's end this
end
return m