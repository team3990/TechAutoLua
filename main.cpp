#include <lua.h>                                /* Always include this when calling Lua */
#include <lauxlib.h>                            /* Always include this when calling Lua */
#include <lualib.h>                             /* Always include this when calling Lua */
#include <stdlib.h>
#include "luawrapper.h"

int main(void) {
	LuaWrapper * wrapper = new LuaWrapper;
	int base = 4;
	int exposant = 0;

	wrapper->PushData(Lua_TypeInt, "base", (void*)&base, true);
	wrapper->PushData(Lua_TypeInt, "exposant", (void*)&exposant, true);

	for(int i = 0; i < 15; i++)
	{
		exposant = i;
		wrapper->Update();
	}

	return 0;
}
