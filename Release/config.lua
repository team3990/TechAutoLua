m = {}
-- Files
separator = package.config:sub(1, 1)
m.F_separator = separator
m.F_fileformat   = "%s.lua"
m.F_moduleformat = string.format("Modules%s.lua", separator.."%s") -- Slightly sketchy
m.F_instrucfile  = "test.txt"

--Outputs
m.OUT_BaseDefaultSpeed = 1
m.OUT_BaseProxSpeed    = 0.5
m.OUT_MoveBrasSpeed    = 0.5
m.OUT_RamasseurSpeed   = 0.5
 
--Count
m.VAL_RamasseurLoops   = 30 -- Nombre de boucles autonomes pour que le ramasseur cesse d'éjecter
m.VAL_BaseProxValue    = 20 -- Proximité nécessaire pour que MoveLinear passe en vitesse réduite
m.VAL_BaseStopValue    = 5  -- Proximité à laquelle MoveLinear s'arrête
m.VAL_TimePerLoop      = 20 -- In milliseconds

--Parser
m.STR_CommandRegex      = "(%([^%)]+%))" -- Trouve la premiere occurence de (...). Lire comme (\([^\)]+\))
m.STR_ParallelToken    = "*"
m.STR_MultitaskToken   = "&"
m.STR_CommentChar      = "#"

--Flags
m.FLAG_ResetEncoder    = 1

--Sys Commands
m.SYS_debug  = true
m.SYS_dircmd = "dir /B \"%s\""
tries = {"ls %s", "dir /B \"%s\""}
for i = 1, #tries do
	x, y, z = os.execute(string.format(tries[i], ""))
	if(z == 0) then -- Success
		m.SYS_dircmd = tries[i]
		break
	end
end

tries = nil

return m
