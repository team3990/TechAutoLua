m = {}

m.name = "Bouger le bras"
local startcounter  = 0
local nbloops = 0 -- Nombre de tours à faire
function m.init(ArgTable)
	startcounter = autocounter + 1 -- On va commencer apres
	nbloops = ArgTable[1]
	
end

function m.body()
	MoteurBras = 0.5
	print((autocounter - startcounter).." Tours")
end

function m.isdone()
	cond = ((autocounter - startcounter) >= nbloops)
	if(cond) then 
		MoteurBras = 0
		print "Bras rendu. En theorie. "
			
	end
	return cond
	
end


return m