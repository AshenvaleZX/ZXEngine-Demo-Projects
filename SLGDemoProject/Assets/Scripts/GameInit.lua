require("Configs/GlobalConst")
require("Configs/MapConfig")
require("MapMgr")

local GameInit = NewGameLogic()

function GameInit:Start()
    GetMapMgr():Init()
end

function GameInit:Update()
    GetMapMgr():Update()
end

return GameInit