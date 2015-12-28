local m = {}


m.name = "Wait for all parallel commands to be completed"


function m.init(ArgTable)
end

function m.body()
end


function m.isdone()
		return(ModuleContainer.GetLength("parallel") == 0)
end

function m.whendone()		
end





return m