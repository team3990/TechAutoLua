require "config"
local m = {}


m.name = "Wait for a time (millis)"
local startloop = 0
local timearg   = 0

function m.init(ArgTable)
	startloop = autoloop
	if(ArgTable[1] > 0) then timearg = ArgTable[1] end
end

function m.body()
end


function m.isdone()
		return((autoloop - startloop) * config.VAL_TimePerLoop) > timearg
end

function m.whendone()		
end





return m