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


class LuaWrapper {
public:
	LuaWrapper();
	virtual ~LuaWrapper();
	void Update();
	void PushData(char, const char*, void*, bool);


private:
	lua_State * L;
	void WriteAllData();
	void WriteData(WrapperData*);
	void ReadAllData();
	void ReadData(WrapperData*);

	std::vector<WrapperData*> data;





};

#endif /* LUAWRAPPER_H_ */
