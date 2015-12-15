local m = {}


m.name = "Wait for all parallel commands to be done"


function m.init(ArgTable)
end

function m.body()
end


function m.isdone()
		return(#paralleltasks == 0) 
end

function m.whendone()		
end





return m