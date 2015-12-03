/*
 * LuaWrapper.cpp
 *
 *  Created on: 2015-12-02
 *      Author: 11110305
 */

#include "LuaWrapper.h"

LuaWrapper::LuaWrapper()
{
	// TODO Auto-generated constructor stub

	// Creating the object, opening the libs, loading the file, making a priming run.
	L = luaL_newstate();
	luaL_openlibs(L);
	luaL_loadfile(L, "helloscript.lua"); // Load file
	lua_pcall(L, 0, 0, 0);            // Priming run: Exec script, but keep variables



}

LuaWrapper::~LuaWrapper()
{
	for(unsigned int i = 0; i < data.size(); i++)
	{
		delete data[i];
	}
	delete L;
}

void LuaWrapper::PushData(char type, const char* name, void* value, bool input)
{
	WrapperData * wrapper = new WrapperData;
	wrapper->type         = type;
	wrapper->name         = name;
	wrapper->WrapperValue = value;
	wrapper->input        = input;
	data.push_back(wrapper);


}

void LuaWrapper::Update()
{
	WriteAllData();
	lua_getglobal(L, "update");
	lua_pcall(L, 0, 0, 0);
}

void LuaWrapper::WriteAllData()
{
	for(unsigned int i = 0; i < data.size(); i++)
	{
		WrapperData * variable = data[i];
		if(variable->input)
		{
			WriteData(variable);
		}


	}
}


void LuaWrapper::WriteData(WrapperData * variable)
{
	switch(variable->type)
	{
	case Lua_TypeInt:
		lua_pushinteger(L, *((int*)variable->WrapperValue));
		break;

	case Lua_TypeFloat:
		lua_pushnumber(L, *((float*)variable->WrapperValue));
		break;

	case Lua_TypeBool:
		lua_pushboolean(L, *((bool*)variable->WrapperValue));
		break;

	case Lua_TypeString:
		lua_pushstring(L, (const char *)variable->WrapperValue);
		break;

	}
	lua_setglobal(L, variable->name);
}

