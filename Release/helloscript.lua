local foo = require "helloscript__"

MoteurVitesse = 0;
distance = 0;

distancecible = 25;

EstInit = false
EstFini = false

function update()
	foo.foo();
	if(not EstInit) then 
		ResetEncoder() 
		EstInit = true
		return 
	
	end
	
	if(math.abs(distance-distancecible) < 0.20) then
		EstFini = true
		MoteurVitesse = 0;

		
	elseif(distance > distancecible) then
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
	--print("Vitesse de moteur: "..MoteurVitesse);
	--print("Distance parcourue: "..distance);
	--print("Distance ciblee: "..distancecible);
	--print(string.rep("-", 35))
	

end
	
	