local module = {}

distancecible = 0

function module.init(ArgTable)

		if ResetEncoder == nil then print "gooby pls"
		else ResetEncoder()
	
		end
		
		distancecible = ArgTable[0]
		
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

end

function module.isdone()
		return(math.abs(distance-distancecible) < 0.20)
	
end

return module