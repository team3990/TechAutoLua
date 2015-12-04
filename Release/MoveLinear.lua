local module = {}

m.name = "Faire bouger le ballon avec des encodeurs"
local distancecible = 0

function module.init(ArgTable)
		print(ArgTable[1])
		if ResetEncoder then 
			ResetEncoder()
		else 
			print "gooby pls" -- ResetEncoder n'est pas défini. Quelqu'un exécute probablement ce programme avec le programme générique.
	
		end
		
		distancecible = ArgTable[1]
		
end

function module.body()
	if(distance > distancecible) then
		if ((distance - distancecible) < 2) then
				MoteurVitesse = -0.5;
		else
				MoteurVitesse = -1
		end
	
	elseif (distance < distancecible) then
		if ((distancecible - distance) < 2) then
				MoteurVitesse = 0.5;
		else	
			MoteurVitesse = 1;
	
		end
	
	end
	print("Distance parcourue: "..distance);

end

function module.isdone()
		
		local cond = (math.abs(distance - distancecible) < 0.20)
		if(cond) then
			MoteurVitesse = 0;
			print "Cible d'encodeurs atteinte."
		
		end
			
		return cond
	
end



return module