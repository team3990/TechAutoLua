local m = {}


m.name = "Wait for a/all parallel command(s) to be completed"

local cmd = nil

function m.init(ArgTable)
	if #ArgTable > 0 then
		cmd = {}
		for i = 1, #ArgTable do
			cmd[i] = ArgTable[i]:lower()
		end
	
	end

end

function m.body()
end


function m.isdone()
		
		if(#Parallels == 0) then 
			return true
		elseif(not cmd)     then return false
		end
		
		for i = #cmd, 1, -1 do
			rawname = cmd[i]
			for i = 1, #Parallels do
				if(Parallels[i].rawname == rawname) then
					cmd[i] = nil
					break
				end
			end
		end

		return(#cmd == 0)
end

function m.whendone()		
end





return m