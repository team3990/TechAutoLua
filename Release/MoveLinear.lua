require "config"
local m = {}


m.name = "Faire bouger le ballon avec des encodeurs"
local distancecible = 0


function m.init(ArgTable)
		print(ArgTable[1])
		if ResetEncoder then 
			ResetEncoder()
		else 
			print "gooby pls" -- ResetEncoder n'est pas défini. Quelqu'un exécute probablement ce programme avec le programme générique.
	
		end
		
		distancecible = ArgTable[1]
		
end

function m.body()
	MoteurVitesse = config.OUT_BaseDefaultSpeed
	if(math.abs(distance - distancecible) < config.VAL_BaseProxValue) then
		MoteurVitesse = config.OUT_BaseProxSpeed
	
	end
	
	if(distance > distancecible) then
		MoteurVitesse = -MoteurVitesse 
	end


end


function m.isdone()
		
		local cond = math.abs(distance - distancecible) < config.VAL_BaseStopValue
		if cond then MoteurVitesse = 0 end
		return cond
		

	
end





return m