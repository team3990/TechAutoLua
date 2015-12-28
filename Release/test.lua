cont = dofile("ModuleContainer.lua")
loa = dofile("ModuleLoader.lua")
Tools = dofile("Tools.lua")
autocounter = 0
function loadstring(meh) return function() end end

cmds = loa.ReadCommands()
Tools.prettyprinter(cmds[1][1])
cont.PushContainer("bleh")
cont.PushModule("bleh", cmds[1][1])
cont.PushModule("bleh", cmds[1][2])