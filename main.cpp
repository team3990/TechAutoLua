#include "stdlib.h"
#include "stdio.h"
#include "cstdlib"
#include "math.h"
#include "sys/time.h"
#include "unistd.h"
#include "iostream"

#include "luawrapper.h"



void foo();

struct timeval time1;

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
			break;
		}
	}

}
