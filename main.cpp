#include <lua.h>                                /* Always include this when calling Lua */
#include <lauxlib.h>                            /* Always include this when calling Lua */
#include <lualib.h>                             /* Always include this when calling Lua */
#include <stdlib.h>

#include "luawrapper.h"
#include <stdio.h>
#include "unistd.h"
#include "iostream"
#include <cstdlib>

#include "sys/time.h"

struct timeval time1;
struct timeval time2;


int main(void) {
	LuaWrapper * wrapper = new LuaWrapper;

	float MoteurVitesse = 0;
	float MoteurRotation = 0;
	float MoteurBras   = 0;
	float MoteurRamasseur   = 0;

	bool RamasseurSwitch  = false;
	bool EstFini          = false;
	float SwitchBidon     = 0;
	float distance = 2423444; // Bidon
	int counter = 0; // Compteur de loops
	//std::cin >> distance;

	const float DistanceParBoucle = 0.75; // En centimètres ...

	gettimeofday(&time1, NULL);
	wrapper->PushData(Lua_TypeFloat, "MoteurVitesse",         (void*)&MoteurVitesse, true);     // Lua -> MoteurVitesse
	wrapper->PushData(Lua_TypeFloat, "MoteurRotation",        (void*)&MoteurRotation, true);    // Lua -> MoteurVitesse
	wrapper->PushData(Lua_TypeFloat, "MoteurBras",            (void*)&MoteurBras, true);        // Lua->MoteurBras
	wrapper->PushData(Lua_TypeFloat, "MoteurRamasseur",       (void*)&MoteurRamasseur, true);   // Lua->MoteurRamasseur
	wrapper->PushData(Lua_TypeBool,  "RamasseurSwitch",       (void*)&RamasseurSwitch, false);  // RamasseurSwitch -> Lua
	wrapper->PushData(Lua_TypeFloat, "distance",              (void*)&distance, false);
	wrapper->PushData(Lua_TypeInt  , "autocounter",           (void*)&counter, false);
	wrapper->PushData(Lua_TypeBool,  "EstFini",               (void*)&EstFini, true);         // Distance -> Lua

	while(1)
	{
		counter++;

		distance += DistanceParBoucle * MoteurVitesse;

		SwitchBidon += MoteurRamasseur;

		if(SwitchBidon > (4.2 + rand() % 5))
		{
			// Prétendons que le ballon est à l'intérieur

			SwitchBidon = 0;
			RamasseurSwitch = true;
		}

		if(MoteurRamasseur < 0)
		{
			SwitchBidon = 0;
			RamasseurSwitch = false;
		}

		wrapper->Update();

		std::vector<int> * actions = wrapper->GetActions();
		for(unsigned int i = 0; i < (*actions).size(); i++)
		{
			int val = (*actions)[i];

			// La switch ne voulait pas marcher.
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

		(*actions).clear(); // Vider le vecteur, maintenant que toutes les actions ont été exécutées



		if(EstFini)
		{
			printf("\n%f\n", distance);
			break;
		}
		usleep(30000);

	}

	gettimeofday(&time2, NULL);
	std::cout << std::endl << ((double)(time2.tv_usec + time2.tv_sec * 100000 - time1.tv_sec * 100000 - time1.tv_usec)) / counter;

}
