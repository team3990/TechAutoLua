m = {}

function m.append(_table, item)
	_table[#_table + 1] = item
end

function m.prettyprinter(_table, indent)
	if not indent then indent = 0 end
	local tabindent =  string.rep("  ", indent)
	print (tabindent.."{")
	for i = 1, #_table do
		if(type(_table[i]) == type({})) then
			m.prettyprinter(_table[i], indent + 1)
		
		else
			print(tabindent .." "..i..": ".. tostring(_table[i]))
			
		end
	end
	print (tabindent.."}")
end

return m