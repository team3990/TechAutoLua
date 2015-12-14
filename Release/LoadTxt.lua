m = {}

currentline = ""


-- Pris sur les internets 
function split(inputstr)

        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^%s]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end


function securityparse()
	line = currentline
	elements = split(line)

	name = elements[1]
	for i = 2, #elements do	
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

function m.parse(line)
		currentline = line
		outcome, result = pcall(securityparse);
		if(outcome) then return result
		else
			print("Bork when parsing line "..line..". Here is the error message: "..result)
			return {}
		
		end

end

return m