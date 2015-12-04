MoveLinear = require "MoveLinear"
if(MoveLinear == nil) then print("yo"); a = 1/0; end


MoveLinear.IsInit = false
MoveLinear.IsDone = false

print("foo")
MoteurVitesse    = 0.0
MoteurRotation   = 0.0
MoteurBras       = 0.0
MoteurRamasseur  = 0.0
distance         = 0.0


RamasseurSwitch  = false
EstFini          = false

function update()
	--print("In update")

	if(MoveLinear.IsDone == true) then return end -- C'EST FINI :CCCCccccc
	
	if(MoveLinear.IsInit == false) then
		ArgTable = {} 
		ArgTable[0] = 50.00
		
		MoveLinear.init(ArgTable)
		MoveLinear.IsInit = true
		return
	end
	
	if(MoveLinear.isdone()) then 
		MoveLinear.IsDone = true
		EstFini           = true
		return
	end
	
	MoveLinear.body();
	print("Vitesse du moteur: "..MoteurVitesse);
	print("Distance parcourue: "..distance);
	print("Distance a parcourir: "..distancecible);
	print(string.rep("_", 35))
		

end
