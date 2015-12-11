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
	if(distance > distancecible) then
		if ((distance - distancecible) < 20) then
				MoteurVitesse = -0.5;
		else
				MoteurVitesse = -1
		end
	
	elseif (distance < distancecible) then
		if ((distancecible - distance) < 20) then
				MoteurVitesse = 0.5;
		else	
			MoteurVitesse = 1;
	
		end
	
	end

end


function m.isdone()
		
		local cond = math.abs(distance - distancecible) < 1
		if cond then MoteurVitesse = 0 end
		return cond
		

	
end





return m