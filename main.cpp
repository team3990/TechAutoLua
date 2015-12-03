#include <lua.h>                                /* Always include this when calling Lua */
#include <lauxlib.h>                            /* Always include this when calling Lua */
#include <lualib.h>                             /* Always include this when calling Lua */
#include <stdlib.h>
#include "luawrapper.h"
#include <stdio.h>
#include "iostream"


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
	float distance = 0;

	const float DistanceParBoucle = 0.5; // En centimètres ...

	wrapper->PushData(Lua_TypeFloat, "MoteurVitesse", (void*)&MoteurVitesse, true);
	wrapper->PushData(Lua_TypeFloat, "distance",      (void*)&distance, false);

	while(1)
	{

		printf("MoteurVitesse: %f\n", MoteurVitesse);
		printf("Distance parcourue: %f\n", distance);
		distance += DistanceParBoucle * MoteurVitesse;
		wrapper->Update();
		if(MoteurVitesse == 0)
		{
			printf("MoteurVitesse: %f\n", MoteurVitesse);
			printf("Distance parcourue: %f\n", distance);
			break;
		}



	}
}
