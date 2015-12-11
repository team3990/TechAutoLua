/*
 * LuaWrapper.h

 *
 *  Created on: 2015-12-02
 *      Author: 11110305
 */

#ifndef LUAWRAPPER_H_
#define LUAWRAPPER_H_

#include <vector>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <iostream>




struct WrapperData
{
	char type; // Look below
	const char* name; // Name of the variable in lua
	void * WrapperValue;
	bool output; // In or out
};


const char Lua_TypeInt    = 0;
const char Lua_TypeFloat  = 1;
const char Lua_TypeBool   = 2;
const char Lua_TypeString = 3;


const int LUAFlag_ResetGyro = 0;
const int LUAFlag_ResetEncoder = 1;




class LuaWrapper {
public:
	LuaWrapper();
	virtual ~LuaWrapper();

	void LoadFile(const char * file);
	void Update();
	void PushData(char, const char*, void*, bool);
	void PushVariable(const char * name, const char* value); // Strings
	void PushVariable(const char * name, int value); // Ints
	void PushVariable(const char * name, float value); // Floats
	void PushVariable(const char * name, bool value); // Bools
	std::vector<int> * GetActions();





private:
	lua_State * L;
	void WriteAllData();
	void ReadAllData();
	void WriteData(const char*, void*, char);
	void ReadData(const char*, void*, char);


	std::vector<WrapperData*> data;





};

#endif /* LUAWRAPPER_H_ */
