Wrapper Lua, par Olivier Lalonde.

1) Pour ce qui est du (des) fichier(s) de commandes
	test.txt.  Chaque commande prend une ligne, dans la syntaxe suivante:
		->[module] [arguments]
		
	Pour l'instant, les arguments ne peuvent être que des nombres (entiers, floats, etc.) et des booléens, et ça devrait amplement suffire.
	
	Les commandes sont exécutées dans l'ordre. 
	Il existe également quelques hacks pour faire des choses plus compliquées.
	1.1) Commandes parallèles
		Syntaxe:
			->*[module] [arguments]
		Sont initialisées en même temps que la commande non parallèle la plus proche par en haut.  Donc:
	
			foo 115
			*foobar 22
			*foobarbar 23
			foo2 116
			
		Ici, foo sera exécuté.  foobar et foobarbar seront exécutés en même temps.  Quand foo sera fini, foo2 embarquera, même si foobar et foobarbar roulent toujours.
		
		Comme leur nom l'indique, une fois initialisées, les commandes parallèles sont entièrement indépendantes des commandes linéaires.  À la fin du fichier de commandes, 
		si les actions linéaires sont terminées mais il reste des commandes parallèles, le programme se terminera. 
		
	1.2) Commandes concurrentes
		Syntaxe:
			->&([module] [arguments]) ([module2] [arguments2])
		
		Même principe que les commandes parallèles (module1 et module2 seront tous les deux exécutés), mais la commande est traitée comme linéaire. Donc:
			&(foo 115) (foobar 666)
			foo2 13
		
		foo et foobar seront exécutés simultanément, mais foo2 ne sera pas exécuté tant que les deux ne seront pas finis. 
		
	1.3) A ne pas faire
		Mon parseur (qui est fait 100% maison) est quand même vraiment sketch.  Donc, choses à éviter:
			foo 10 // 10 tours
			*foobar 22 // 22 tours
			foobar 23 // 23 tours
			
		Ici, le deuxième foobar sera appelé alors que le premier roule toujours.  Dans ce cas spécifique, il ignorerait le deuxième, mais si ce code
		continuait avec une autre commande parallèle, cela déclencherait une apocalypse nucléaire.  
		
		De plus, il supporte très mal les commandes nestées.  Donc, pas de &(foo2)(&(foo3)(foo4)), ça détruirait tout.  
		
		Je crois qu'il est assez correct, mais quoi que ce soit de malhonnête risque de le briser assez sérieusement.
		
2) Écrire des commandes
	Super simple.  Il faut d'abord créer un fichier lua, et faire la procédure habituelle: Déclarer une table, la retourner à la fin du fichier
    (constituant le module). Tout ce qui doit être exporté doit être déclaré comme faisant partie de cette table. Exemple:
	
	// foo.lua
		local m = {}
		m.patate = "Miam miam des patates"
		return m
		
	// foo2.lua
		require "foo"
		print(foo.patate) // Miam miam des patates
		
	Les fonctions qui doivent être définies dans votre programme sont:
		- init(Argtable) où Argtable est une table des arguments parsés.  Sera appelé une seule fois, après la création du module.
		- body()         Appelé à chaque tour si isended() retourne false.
		- IsDone()       Retourne bool. Si vrai, commande est considérée comme finie.
	
	Les variables accessibles (celles qui seront créées, settées et lues par le programme C++) sont:
		- MoteurVitesse   (float)
		- MoteurRotation  (float)
		- MoteurBras      (float)
		- MoteurRamasseur (float)
		- distance        (float)
		- autocounter     (int)
		- RamasseurSwitch (bool)
		- EstFini         (bool)
		
		
		