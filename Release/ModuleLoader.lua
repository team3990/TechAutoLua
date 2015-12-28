Tools = require "Tools"
config = require "config"
m = {}

PreloadedModules = {} -- cmdname:module

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





function m.ReadCommands()
	--[[ Parses the file. Works like this:
	foo 2
	foobar 3
	*foobar 4
	
	********INTO:*************
	{
	  {
		{"foo", 2}
	  }, 
	  {
		{foobar, 3}, 
		{foobar 4}
	  }
	 }
	
	--]]
	
	local file = io.open(config.F_instrucfile, "r")
	local index = 0
	Commands = {}
	while true do

		local str = file:read("*line")
		
		if str == nil then
			break -- EOF
		end
		
		str = string.gsub(str, config.STR_CommentChar..".*", "") -- Strip comment line
		if #str > 0 then
			local firstchar = str:sub(1, 1)
			if (firstchar == config.STR_ParallelToken) then
				-- Parallel
				if(#Commands[index]) then
					Tools.append(Commands[index], LoadArguments(string.sub(str, 2, -1)))
					
				end
				
			else
				-- Not parallel: Start of a new block
				index = index + 1
				Tools.append(Commands, {})
			
				command = {}
				
				if (firstchar == config.STR_MultitaskToken) then
					-- Create a multitask object and put stuff in it
					_index = 1
					
					while 1 do
						_, _index, subcommand = string.find(str, config.STR_CommandRegex) -- Find first occurence of (...)
						if(not subcommand) then break end -- Stahpings
						str = str:sub(_index)
						Tools.append(command, LoadArguments(subcommand:sub(2, -2)))


					end
				
				else
					command = LoadArguments(str);
				end
				
				Tools.append(Commands[index], command)
				
			end
				
			
			end
		end
				
		
		return Commands
end


function LoadArguments(arg)
	arg = Tools.split(arg) 
	
	for i = 2, #arg do
		assert(loadstring("value="..arg[i]))() -- Slightly hackish, but saves a lot of work
		
		arg[i] = value
		
	end
	print(string.rep("-", 50))
	Tools.prettyprinter(arg)
	print(string.rep("-", 50))
	if(#arg > 0) then
		return LoadModule(arg)
	else
		return {}

	end
end

function LoadModule(args)
	name = args[1]
	print("Loading: "..name)
	args = Tools.tableindex(args, 2, 0)
	
	local newmodule;
	if(PreloadedModules[name:lower()]) then
		newmodule = PreloadedModules[name:lower()]
		
	else
		files = Tools.listdir(string.format(config.F_moduleformat, "*"))
		local path;
		
		-- To prevent any shenanigans with linux being case-sensitive
		for i = 1, #files do
			filename = files[i]
			
			if(Tools.getindex(filename, #name + 1) == ".") then -- To make sure "foobar.lua" doesn't match "foo"
				filename = filename:sub(1, #name)

				if(filename:lower() == name:lower()) then
					path = string.format(config.F_moduleformat, filename)
					break
				end
			end
		end
	
		if(path) then
			result, newmodule = Tools.safecall(function() return dofile(path) end, "Module is broken. ")
			newmodule.rawname = name
			if(not result) then -- Börk
				return {}
			end
			PreloadedModules[name:lower()] = newmodule -- A new module is born
		else 
			print("Did not work")
			return {}
		end
	end
			
	if(newmodule.ArgTemplates) then
		if(not AnalyseArgs(args, newmodule.ArgTemplates)) then
			print("*** Bad arguments: skipping.")
			return {}
		end
			
	end
		
	newargs = {newmodule}
	Tools.extend(newargs, args)
	return newargs
end

return m
	
	
	