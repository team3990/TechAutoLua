#include <lua.h>                                /* Always include this when calling Lua */
#include <lauxlib.h>                            /* Always include this when calling Lua */
#include <lualib.h>                             /* Always include this when calling Lua */
#include <stdlib.h>
#include "stdio.h"
#include "luawrapper.h"
#include <stdio.h>
#include "unistd.h"
#include "iostream"
#include <stdio.h>
#include <unistd.h>

#include "sys/time.h"

struct timeval time1;
struct timeval time2;


int main(void) {
	LuaWrapper * wrapper = new LuaWrapper;

	/*
	// Comme on est dans l'exponentiel en maths...
	int base = 4;
	int exposant = 0;
	int puissance = 0;

	bool foo = true;


	wrapper->PushData(Lua_TypeInt, "base", (void*)&base, false);
	wrapper->PushData(Lua_TypeInt, "exposant", (void*)&exposant, false);
	wrapper->PushData(Lua_TypeBool, "nombre", (void*)&foo, true);


	wrapper->PushData(Lua_TypeInt, "puissance", (void*)&puissance, true); // Output


	for(int i = 0; i < 15; i++)
	{

		exposant = i;
		wrapper->Update();
		printf("%d\n", puissance);
		printf(foo ? "true\n" : "false\n");
	}

	return 0;
	*/

	float MoteurVitesse = 0;
	float MoteurRotation = 0;
	float MoteurBras   = 0;
	float MoteurRamasseur   = 0;

	bool RamasseurSwitch  = false;
	bool EstFini          = false;
	float distance = 2423444; // Bidon
	//std::cin >> distance;

	const float DistanceParBoucle = 0.5; // En centimètres ...

	wrapper->PushData(Lua_TypeFloat, "MoteurVitesse",         (void*)&MoteurVitesse, true);     // Lua -> MoteurVitesse
	wrapper->PushData(Lua_TypeFloat, "MoteurRotation",        (void*)&MoteurRotation, true);    // Lua -> MoteurVitesse
	wrapper->PushData(Lua_TypeFloat, "MoteurBras",            (void*)&MoteurBras, true);        // Lua->MoteurBras
	wrapper->PushData(Lua_TypeFloat, "MoteurRamasseur",       (void*)&MoteurRamasseur, true);   // Lua->MoteurRamasseur
	wrapper->PushData(Lua_TypeBool , "RamasseurSwitch",       (void*)&RamasseurSwitch, false);  // RamasseurSwitch -> Lua
	wrapper->PushData(Lua_TypeFloat, "distance",              (void*)&distance, false);
	wrapper->PushData(Lua_TypeBool,  "EstFini",               (void*)&EstFini, true);         // Distance -> Lua


	gettimeofday(&time1, NULL);
	int counter = 0;
	while(1)
	{
		counter++;

		//timestamp1 = time1.tv_usec;
		distance += DistanceParBoucle * MoteurVitesse;
		wrapper->Update();

		std::vector<int> * actions = wrapper->GetActions();
		for(unsigned int i = 0; i < (*actions).size(); i++)
		{
			int val = (*actions)[i];
			printf("%d", val);

			if(val == LUAFlag_ResetEncoder)
			{
				distance = 0;
				printf("\nL'encodeur est reinitialise :)\n");
			}

			else if (val == LUAFlag_ResetGyro)
			{
				printf("\nLe gyro est reinitialise :)\n");
			}

		}

		*actions = std::vector<int>(); // New one pls


		if(EstFini)
		{
			printf("\n%f\n", distance);
			break;
		}

	}

	gettimeofday(&time2, NULL);
	std::cout << std::endl << ((double)(time2.tv_usec + time2.tv_sec * 100000 - time1.tv_sec * 100000 - time1.tv_usec)) / counter;

}
