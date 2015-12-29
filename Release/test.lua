splittedline = {}
current = ""
isstring = false
arg = "ohai there \"foooooo ooo oo o\" asd"

for i = 1, #arg do
	_char = arg:sub(i, i)
	if(_char == "\"") then
		if(isstring) then
			current = current .. "\""
			splittedline[#splittedline + 1] = current
			current = ""
		
		else
			if(#current > 0) then
				splittedline[#splittedline + 1] = current
			end
			current = "\""
		end
		isstring = not isstring
	
	elseif isstring or (not string.match(_char, "%s")) then
		current = current .. _char
	
	elseif(string.match(_char, "%s") and (not isstring) and (#current > 0)) then
		splittedline[#splittedline + 1] = current
		current = ""
	
	end
end
splittedline[#splittedline + 1] = current
