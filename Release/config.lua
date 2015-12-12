m = {}


-- Files
m.F_fileformat   = "%s.lua"
m.F_moduleformat = "%s.lua"
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

--Parser
m.STR_ActionRegex      = "(%([^%)]+%))" -- Trouve la premiere occurence de (...) 
m.STR_ParallelToken    = "*"
m_STR_MultitaskToken   = "&"

return m