/*
 * LuaWrapper.cpp
 *
 *  Created on: 2015-12-02
 *      Author: 11110305
 */

#include "LuaWrapper.h"
#include "string.h"

std::vector<int> actions = std::vector<int>();



void Lua_PushAction(int flag)
{
	actions.push_back(flag); // Actions exécutées par le programme C++ (ResetEncoder, ResetGyro, etc. )
}

// Commandes passees directement a lua (d'ou le static)

static int Lua_ResetGyro(lua_State * L)
{
	Lua_PushAction(LUAFlag_ResetGyro);
	return 0;
}

static int Lua_ResetEncoder(lua_State * L)
{
	Lua_PushAction(LUAFlag_ResetEncoder);
	return 0;
}





LuaWrapper::LuaWrapper()
{
	// TODO Auto-generated constructor stub

	// Creating the object, opening the libs, loading the file, making a priming run.
	L = luaL_newstate();

	LoadFile("AutoFrame.lua");




}

LuaWrapper::~LuaWrapper()
{
	for(unsigned int i = 0; i < data.size(); i++)
	{
		delete data[i];
	}
	delete L;
}

void LuaWrapper::LoadFile(const char * file)
{
	lua_settop(L, 0); // Clear the stack
	luaL_openlibs(L); // Load libs
	luaL_loadfile(L, file); // Load file

	lua_pushcfunction(L, Lua_ResetEncoder);
	lua_setglobal(L, "ResetEncoder"); // Set function

	lua_pushcfunction(L, Lua_ResetGyro);
	lua_setglobal(L, "ResetGyro"); // Set function


	lua_pcall(L, 0, 0, 0);            // Priming run: Exec script, but keep variables

}
void LuaWrapper::PushData(char type, const char* name, void* value, bool output)
{
	WrapperData * wrapper = new WrapperData;
	wrapper->type         = type;
	wrapper->name         = name;
	wrapper->WrapperValue = value;
	wrapper->output       = output;
	data.push_back(wrapper);


}

void LuaWrapper::PushVariable(const char * name, const char * value)
{
	lua_pushstring(L, value);
	lua_setglobal(L, name);
}

void LuaWrapper::PushVariable(const char * name, int value)
{
	lua_pushinteger(L, value);
	lua_setglobal(L, name);
}
void LuaWrapper::PushVariable(const char * name, float value)
{
	lua_pushnumber(L, value);
	lua_setglobal(L, name);
}
void LuaWrapper::PushVariable(const char * name, bool value)
{
	lua_pushboolean(L, value);
	lua_setglobal(L, name);
}

std::vector<int> * LuaWrapper::GetActions()
{
	return &actions; // Pour éviter des foirages de link, actions n'est pas dans le .h
}
void LuaWrapper::Update()
{
	WriteAllData();
	lua_getglobal(L, "update");
	lua_pcall(L, 0, 0, 0);
	ReadAllData();

	for(unsigned int i = 0; i<actions.size(); i++)
	{
		std::cout << actions[i];
	}
}

void LuaWrapper::WriteAllData()
{
	for(unsigned int i = 0; i < data.size(); i++)
	{
		WriteData(data[i]->name, data[i]->WrapperValue, data[i]->type);
	}
}



void LuaWrapper::WriteData(const char * name, void * value, char type)
{
	switch(type)
	{
	case Lua_TypeInt:
		lua_pushinteger(L, *((int*)value));
		break;

	case Lua_TypeFloat:
		lua_pushnumber(L, *((float*)value));
		break;

	case Lua_TypeBool:
		lua_pushboolean(L, *((bool*)value));
		break;

	case Lua_TypeString:
		lua_pushstring(L, *((const char **)value));
		break;

	}
	lua_setglobal(L, name);
}


void LuaWrapper::ReadAllData()
{
	for(unsigned int i = 0; i < data.size(); i++)
	{
		WrapperData * variable = data[i];
		if(variable->output)
		{
			ReadData(variable->name, variable->WrapperValue, variable->type);
		}


	}
}

void LuaWrapper::ReadData(const char * name, void * value, char type)
{
	lua_getglobal(L, name);
	switch(type)
	{
	case Lua_TypeInt:
		*((int *)value) = lua_tointeger(L, -1);
		break;

	case Lua_TypeFloat:
		*((float *)value) = lua_tonumber(L, -1);
		break;

	case Lua_TypeBool:
		*((bool *)value) = lua_toboolean(L, -1);
		break;

	case Lua_TypeString:
		// No const char * values please

		break;

	}

}



