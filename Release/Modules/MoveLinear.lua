require "config"
local m = {}


m.name = "Faire bouger le ballon avec des encodeurs"
local distancecible = 0

m.InitArgs = {
	{type(float)}
}


function m.init(ArgTable)
		print(ArgTable[1])
		if PushAction then 
			PushAction(config.FLAG_ResetEncoder)
		else 
			print "PushAction not found.  Please run me with the C++ program. "
	
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
		
		return math.abs(distance - distancecible) < config.VAL_BaseStopValue
end

function m.whendone()
		MoteurVitesse = 0
		
end





return m