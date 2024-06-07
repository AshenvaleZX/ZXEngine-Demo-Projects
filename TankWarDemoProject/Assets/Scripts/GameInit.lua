require("Configs/GlobalConst")
require("Configs/MapConfig")
require("MapMgr")
require("CannonMgr")

local GameInit = NewGameLogic()

function GameInit:Start()
    GetMapMgr():Init()
    GetCannonMgr():Init()
end

function GameInit:Update()
end

function GameInit:OnDestroy()
end

return GameInit