Tools = require "Tools"
config = require "config"
m = {}

PreloadedModules = {} -- cmdname:module


function m.ReadCommands()
	--[[ Parses the file. Works like this:
	foo 2
	foobar 3
	*foobarbaz 4
	
	********INTO:*************
	{
	  {
		{[module foo], 2}
	  }, 
	  {
		{[module foobar], 3}, 
		{[module foobarbaz], 4}
	  }
	 }
	
	--]]
	
	local file = io.open(config.F_instrucfile, "r")
	if(not file) then
		print("Fatal error: Could not open command file "..config.F_instrucfile)
		error({})
	end
	
	local index = 0
	Commands = {}
	
	while 1 do

		local str = file:read("*line")
		
		if not str then
			break -- EOF
		end
		
		results = {pcall(function() return AnalyseLine(str) end)}
		if not results[1] then
			if results[2].msg then
				print("Failed to load line: "..results[2].msg)
			else
				print("Caught error when loading line: "..results[2])
			end
			
			if not config.SYS_debug then
				error(results[2])
			end

			
		else
			_table = results[2]
			newblock = results[3]
			
			if newblock then
				Tools.append(Commands, {})
			end
			
			if(#Commands == 0) then
				print("Error: Can't use standalone parallel commands")
			
			elseif _table then
				
				Tools.append(Commands[#Commands], _table)
				
			end
		end

	end
	return Commands
end

function AnalyseLine(line)
		line = string.gsub(line, config.STR_CommentChar..".*", "") -- Strip comment line
		if(not line:match("%S")) then return end -- There's no point in parsing an empty line
		
		local firstchar = line:sub(1, 1)
		local result    = {}
		local newblock  = false
		if (firstchar == config.STR_ParallelToken) then
			-- Parallel
			return LoadArguments(string.sub(line, 2, -1))
				

		else
			-- Not parallel: Start of a new block
			newblock = true
			
			if (firstchar == config.STR_MultitaskToken) then
				-- Create a multitask object and put stuff in it
				
				_index = 1

				local commands = line:findall(config.STR_CommandRegex)
				used = {}
				
				for i = 1, #commands do
					cmd = LoadArguments(commands[i]:sub(2, -2))
	
					if(Tools.count(used, cmd[i]) > 0) then
						error({msg = "Can't run multiple instances of command at the same time ..."})
					
					else
						Tools.append(used, cmd[i])
						Tools.append(result, cmd)
					
					end
				end
			
			else
				result = LoadArguments(line);
				
			end
			
		end
		return result, newblock
			

end
function LoadArguments(arg)
	-- Like a normal whitespace split, but supports strings
	splittedline = {}
	current = ""
	isstring = false
	for i = 1, #arg do
		_char = arg[i]
		if(_char == "\"") then
			if(isstring) then
				current = current .. "\""
				Tools.append(splittedline, current)
				current = ""
			
			else
				if(#current > 0) then
					Tools.append(splittedline, current)
				end
				current = "\""
			end
			isstring = not isstring
		
		elseif isstring or (not string.match(_char, "%s")) then
			current = current .. _char
		
		elseif(string.match(_char, "%s") and (not isstring) and (#current > 0)) then
			Tools.append(splittedline, current)
			current = ""
		
		end
	end
	if(#current > 0) then Tools.append(splittedline, current) end

	arg = splittedline
	
	-- Load arguments to module
	for i = 2, #arg do
		func = loadstring("value="..arg[i]) -- Slightly hackish, but saves a lot of work
		if(not func) then
			error({msg = string.format("Couldn't parse argument #u %s: Not a valid lua literal. ", i, arg[i])})
		end
		
		func()
		arg[i] = value
		
	end
	
	if(#arg > 0) then
		return LoadModule(arg)
	else
		error({msg = "Empty args"})

	end
	
	print("Load Succeeded")
end

function LoadModule(args)
	name = args[1]
	print("Loading: "..name)
	args = Tools.tableindex(args, 2, 0)
	
	local newmodule;
	if(PreloadedModules[name:lower()]) then
		newmodule = PreloadedModules[name:lower()]
		print("Module already loaded. ")
		
	else
		print("Loading module... ")
		files = Tools.listdir(string.format(config.F_moduleformat, "*"))
		local path;
		
		-- To prevent any shenanigans with linux being case-sensitive
		for i = 1, #files do
			filename = files[i]
			
			if(filename[#name + 1] == '.') then -- To make sure "foobar.lua" doesn't match "foo"
				filename = filename:sub(1, #name)

				if(filename:lower() == name:lower()) then
					path = string.format(config.F_moduleformat, filename)
					break
				end
			end
		end
	
		if(path) then
			print("Path found: "..path)
			result, newmodule = pcall(function() return dofile(path) end)
			if(not result) then -- Börk
				error({msg = "Caught exception when loading module: "..newmodule})
			end

			
			newmodule.rawname = name
			PreloadedModules[name:lower()] = newmodule -- A new module is born
		else 
			error({msg = "Path not found in Modules/. "})
		end
	end

	if(newmodule.ArgTemplates) then
		if(not AnalyseArgs(args, newmodule.ArgTemplates)) then
			error({msg = "Arguments did not match known templates. "})
		end
			
	end
	
	newargs = {newmodule}
	Tools.extend(newargs, args)
	return newargs
end

function AnalyseArgs(ArgTable, ArgTemplates)
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


return m
	
	
	