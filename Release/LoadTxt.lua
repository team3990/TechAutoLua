m = {}


-- Pris sur les internets 
function split(inputstr)

        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^%s]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end
function m.parse(line)

	elements = split(line)

	name = elements[1]
	for i=2, #elements do	
		str = elements[i]
		value = nil
		if str == "true" then
			value = true
		
		elseif str == "false" then
			value = false
		
		elseif string.find(str, "[^%d|.|-]") == nil then
			value = tonumber(str)
		
		end
		elements[i] = value


	end
	return elements
	
	
end

return m