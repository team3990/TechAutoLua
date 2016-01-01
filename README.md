Lua Wrapper for FRC robots, by Olivier Lalonde

This wrapper is designed to operate during the autonomous mode. Not only does it use an external command list (without having to recompile every time), but it 
also use external auto command scripts (in lua). The C++ program inputs some variables (like EncoderDistance, autoloop, etc.), executes update() in AutoFrame lua,
then outputs some variables (like DriveForward, DriveRotation, etc.) and uses them to drive the robot:

	robot.cpp:
	EncoderDistance = ReadEncoder();
	// EncoderDistance -> lua

	autoframe.lua:
	function update()
		if EncoderDistance < 30 then MotorDrive = 1 end -- Drive forward
	end
	
	robot.cpp:
	// MotorDrive->cpp
	Robot.Drive(MotorDrive);

That's the basic functionality. As mentioned before, I also coded a module-oriented approach in lua that allows the user to write modules and a text file with
a list of commands.  A module has three functions: init (that will be called with the provided arguments), body (that will be called every loop), and isdone, 
that will be called every loop, and should return the command's state. Example:
	-- Default module: foo.lua
	m = {}
	targetdistance = 0
	function m.init(mytable)
		targetdistance = mytable[0]
	end
	
	function m.body()
		if targetdistance > EncoderDistance then MotorDrive = 1 end
	end
	
	function m.isdone()
		return (targetdistance == EncoderDistance)
	end
	
	function m.whendone()
		MotorDrive = 0
		
		
	end	

	return m
	-- Command file: cmd.txt
	foo 50
	foo 30
	
That code will drive the robot with a forward speed of 1 until the target of 50 is reached.  
Then, it will again drive the robot with a forward speed of 1 until the target of 30 is reached. That program is of course extremely simplified, and it wouldn't
work on a robot. Look at MoveLinear.lua for the real code.
		
HOW TO ADAPT THIS API TO YOUR OWN CODE:

1) C++ side
Include Luawrapper.cpp, luawrapper.h. Compile lua for the roboRIO with the toolchain, include liblua.a, include the h files.  Here's how you use the wrapper:
- To load a file (such as AutoFrame.lua), use LuaWrapper::LoadFile. This function will clear the stack (thereby clearing the memory and deleting the functions), so it is safe to load a file multiple times.

- To update the file, use LuaWrapper::update(). This will input all the provided variables into lua, execute update(), then output all the variables that have to be
  outputted into.
  
- To push a pointer, use LuaWrapper::PushData(type, name, void * pointer, bool output).  Type is a wrapper flag, either Lua_TypeInt for integers, Lua_TypeFloat for floats, Lua_TypeBool for bools, 
  Lua_TypeString for const char *.  Name is the const char * of the name you want this variable to have in lua.  Pointer is a pointer to your object (casted in void *).
  Output is whether or not you want the wrapper to read the lua variable after exec and write its value into your pointer. 
 
- To push a single variable, use LuaWrapper::PushVariable(const char * name, int/float/bool/const char* value).  This will directly push the value into lua.

- Lua will also push flags.  LuaWrapper::GetActions will return a pointer to a vector of flags pushed by lua using GetActions().  E.g. Lua: GetActions(1) -> C++: vector.push_back(1)

2) Command side
Commands generally run in linear fashion. Example:
	foo 2
	foobar 
	foobarbaz 5
Will call foo with arg 2, wait for it to end, then call foobar, wait for it to end, then call foobarbaz with arg 5, and wait for it to end.
There's more advanced stuff you can do.
-Parallel commands
	Will run independently of the linear state of the program. Defined with a *.  Example:
	foo 2
	*foobar
	foobarbaz 5
	will run foo with arg 2, and run foobar.  Will run foobarbaz 5 when foo is done.  foobar will continue running independently.  Note that the program will terminate
	when all linear commands are processed, even if some parallel commands are ongoing. 
	
-Multicommands
	Will run several commands at the same time, but won't continue to the next level until all commands are done. Defined with a &. Example:
	&(foo 2)(foobar)
	foobarbaz
	Will run foo with arg 2 and will run foobar.  When both are complete, foobarbaz will be ran.
	
-Comments
	Work exactly like C++ or Lua commands: Everything past # in a line will be discarded. 
	
3) Lua side
Used to define commands.  Every command name refers to the filename of a module. 
If we write "foo 2" in the command file, AutoFrame.lua will interpret it as "Open foo.lua and call foo.init() with [2]".  
To define a module, create a lua file with your command's name in Modules/.  

How this works is:
When the lua side is called for the first time, it reads the command file, executes all the modules and stores them in a table.  Every module is ran only once.  
Then, when it comes to executing the command, it will deepcopy the original module and call init(). Then, on the following loops, it will run body(), and run IsDone(). If IsDone() returns true or returns an exception, it will call whendone() and repeat the process for the next module.

	