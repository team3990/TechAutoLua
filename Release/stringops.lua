function string.split(str, separator)
	if(not separator) then separator = "%s" end -- Whitecase 
    return str:findall("([^"..separator.."]+)")
 
end

function string.findall(str, pattern)

	local results = {}
	gmatchfunc = str:gmatch(pattern)
	while 1 do
		result = gmatchfunc()
		if(not result) then break end
		results[#results + 1] = result
		
	end
	return results
end

function string.getindex(str, _index)
	if(_index < 1) then _index = #str - _index end
	return str:sub(_index, _index)
end

-- Makes functions in m properties of any string object
getmetatable('').__index =  function(str, _index)
		if(type(_index) == type(2)) then 
			return str:getindex(_index)
		else
			return string[_index]
			
		end
end