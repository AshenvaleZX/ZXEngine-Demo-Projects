require("Configs/GlobalConst")
require("Configs/MapConfig")
require("AStar")
require("MapMgr")
require("CannonMgr")
require("EnemyMgr")

local GameInit = NewGameLogic()

function GameInit:Start()
    GetMapMgr():Init()
    GetCannonMgr():Init()
    GetEnemyMgr():Init()
end

function GameInit:Update()
    GetEnemyMgr():Update()
end

function GameInit:OnDestroy()
end

return GameInit