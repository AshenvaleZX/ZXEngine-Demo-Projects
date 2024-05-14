require("Configs/GlobalConst")
require("Configs/MapConfig")
require("Timer")
require("MapMgr")
require("MapUIMgr")

local GameInit = NewGameLogic()

function GameInit:Start()
    GetMapMgr():Init()
    GetMapUIMgr():Init()
end

function GameInit:Update()
    Timer:Update()
    GetMapMgr():Update()
    GetMapUIMgr():Update()
end

return GameInit