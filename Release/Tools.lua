m = {}


-- Table functions lua badly lacks
function m.append(_table, item)
	_table[#_table + 1] = item
end

function m.extend(_table, extension)
	for i = 1, #extension do
			m.append(_table, extension[i])
	end
end

function m.count(_table, item)
	local count = 0
	for i = 1, #_table do 
		count = count + (_table[i] == item) and 1 or 0
	
	end

end

function m.remove(_table, item)
	for i = _table, 1, -1 do
		if(_table[i] == item) then _table[i] = nil end
	
	end
end


-- Other semi-useful stuff
local function prettyprinter(_table, indent)
	local tabindent =  string.rep("  ", indent)
	print (tabindent.."{")
	for i = 1, #_table do
		if(type(_table[i]) == type({})) then
			prettyprinter(_table[i], indent + 1)
		
		else
			print(tabindent .." "..i..": ".. tostring(_table[i]))
			
		end
	end
	print (tabindent.."}")
end



function m.prettyprinter(_table)
	prettyprinter(_table, 0)
end

function m.safecall(func, errmsg)
	success, result = pcall(func)
	if(not success) then
		print(errmsg)
		print("EXC: "..result)
		return false
	
	else
		return true, result
		
	end
end

return m