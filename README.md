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
		if(targetdistance == EncoderDistance) then
			MotorDrive = 0
			return true
		end
		return false
		
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
- To load a file (such as AutoFrame.lua), use LuaWrapper::LoadFile. This function will clear the stack (thereby clearing the memory and the functions).
- To update the file, use LuaWrapper::

	