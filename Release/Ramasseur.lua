m = {}
m.name = "moo foo"

direction = true -- In. Out = false
startloop      = 0
function m.init(_direction)
	direction = _direction[1] -- Oui ou non
	startloop = autocounter + 1 -- Si vers l'extérieur, il utilisera le nombre de tours pour s'arreter. Sinon, il utilisera la switch bidon.
	if(_direction) then m.name = "Ramasser le ballon" 
	else m.name = "Evacuer le ballon" end
	
end

function m.body()
	MoteurRamasseur = config.OUT_RamasseurSpeed
	if(not direction) then
		MoteurRamasseur = -MoteurRamasseur
	
	end
	print("Exec Ramasseur.body. ")
	
end


function m.isdone()
	return ((direction and RamasseurSwitch) or (not direction and (autocounter - startloop) > config.VAL_RamasseurLoops))

end

function m.whendone()
	MoteurRamasseur = 0 
	if(RamasseurSwitch) then 
		print ("Switch active, ballon a l'interieur")
			
	else
		print ("Ballon a l'exterieur")
		
	end
end

return m