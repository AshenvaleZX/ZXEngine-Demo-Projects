require("Configs/GlobalConst")
require("Configs/MapConfig")
require("MapMgr")
require("MapUIMgr")

local GameInit = NewGameLogic()

function GameInit:Start()
    GetMapMgr():Init()
    GetMapUIMgr():Init()
end

function GameInit:Update()
    GetMapMgr():Update()
end

return GameInit