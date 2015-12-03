#include <lua.h>                                /* Always include this when calling Lua */
#include <lauxlib.h>                            /* Always include this when calling Lua */
#include <lualib.h>                             /* Always include this when calling Lua */
#include <stdlib.h>
#include "luawrapper.h"

int main(void) {
	LuaWrapper * wrapper = new LuaWrapper;

	// Comme on est dans l'exponentiel en maths...
	int base = 4;
	int exposant = 0;
	int puissance = 0;

	wrapper->PushData(Lua_TypeInt, "base", (void*)&base, true);
	wrapper->PushData(Lua_TypeInt, "exposant", (void*)&exposant, true);
	wrapper->PushData(Lua_TypeInt, "puissance", (void*)&puissance, false); // Output

	for(int i = 0; i < 15; i++)
	{
		exposant = i;
		wrapper->Update();
		printf("%d\n", puissance);
	}

	return 0;
}
