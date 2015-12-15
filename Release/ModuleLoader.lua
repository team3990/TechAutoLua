Tools = require "Tools"
config = require "config"
LoadTxt = require "LoadTxt"
m = {}

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


function m.CommandIsDone(_module)
		state, result = Tools.safecall(_module.isdone, string.format("Bork when calling isdone in module %s", _module.rawname))
		if(not state) then return true end
		
		if(result) then
				Tools.safecall(_module.whendone, string.format("Bork when calling whendone in module %s", _module.rawname))
				return true
		end
			
		return false			
end

function m.CommandBody(_module)
	if(_module == nil) then return end
	print("In body ".._module.rawname)
	state, result = Tools.safecall(_module.body, string.format("Bork when calling body in module %s", _module.rawname))
	if(not state) then _module.isdone = (function() return true end) end -- Let's end this
end

function m.InitModule(command)
	if(command == nil) then return end
	if(#command == 0)  then return end
	if(not IsUsed(command[1])) then -- if a module of the same name is still running, manually block it
		print("INIT: "..command[1])
		usedmodules[#usedmodules + 1] = command[1]
		local Argtable = {}
		for i = 2, #command do 
			Argtable[#Argtable + 1] = command[i]

		end
		print("Command 1: "..command[1])
		Tools.prettyprinter(Argtable)
		
		local result, newmodule = Tools.safecall(function() mod = dofile (string.format(config.F_moduleformat, command[1])); return mod end, "Module is broken. ")
		if not result then
			return
		end

		
		if(newmodule.ArgTemplates) then
			if(not AnalyseArgs(Argtable, newmodule.ArgTemplates)) then
					print("*** Bad arguments: skipping.")
					return
			end
			
		end
		success, foo = Tools.safecall(function() newmodule.init(Argtable) end, "*** Module init threw an exception")

		
		if(not success) then
			-- Oh dear
			return 
		end
		newmodule.rawname = command[1]
		return newmodule
	
	end
	
	print("Module "..command[1].." already running...")
	return nil

	
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
	while 1 do

		local str = file:read("*line")
		
		if str == nil then
			break -- EOF
		end
		
		str = string.gsub(str, config.STR_CommentChar..".*", "") -- Strip comment line
		if str ~= "" then
			local firstchar = str:sub(1, 1)
			if (firstchar == config.STR_ParallelToken) then
				-- Parallel
				if(#Commands[index]) then
					Tools.append(Commands[index], LoadTxt.parse(string.sub(str, 2, -1)))
					
				end
				
			else
				-- Not parallel: Start of a new block
				index = index + 1
				Tools.append(Commands, {})
			
				command = {}
				
				if (firstchar == config.STR_MultitaskToken) then
					-- Create a multitask object and put stuff in it
					_index = 1
					moduletable = {"Multitask"} -- That's a module like any other
					subcommand = ""
					str = str:sub(2) -- Remove the token at the beginning
					while 1 do
						_, _index, subcommand = string.find(str, config.STR_CommandRegex) -- Find first occurence of (...)
						if(not subcommand) then break end -- Stahpings
						str = str:sub(_index)
						Tools.append(moduletable, subcommand:sub(2, -2))

					end
					
					command = moduletable

				else
					command = LoadTxt.parse(str);
				end
				
				print("COMMAND NAME:"..command[1])
				Tools.append(Commands[index], command)
				
			end
				
			
			end
		end
		
		return Commands
end


		
return m