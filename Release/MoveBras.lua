require "config"
m = {}

m.name = "Bouger le bras"
local startcounter  = 0
local nbloops = 0 -- Nombre de tours à faire
local direction = true -- Par en avant.
function m.init(ArgTable)
	startcounter = autocounter + 1 -- On va commencer apres
	nbloops = ArgTable[1]
	direction = ArgTable[2]
	
end

function m.body()
	MoteurBras = config.OUT_MoveBrasSpeed
	
	if not direction then
		MoteurBras = -MoteurBras
	
	end
end

function m.isdone()
	cond = ((autocounter - startcounter) >= nbloops)
	if(cond) then 
		MoteurBras = 0
			
	end
	return cond
	
end


return m