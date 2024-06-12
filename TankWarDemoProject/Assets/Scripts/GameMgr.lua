require("Configs/GlobalConst")
require("Configs/MapConfig")
require("AStar")
require("MapMgr")
require("CannonMgr")
require("EnemyMgr")

local GameMgr = NewGameLogic()

GameMgr.Paused = false

function GetGameMgr()
    return GameMgr
end

function GameMgr:Start()
    GetMapMgr():Init()
    GetCannonMgr():Init()
    GetEnemyMgr():Init()
end

function GameMgr:Update()
    GetEnemyMgr():Update()
end

function GameMgr:Restart()
    GetTank():Reset()
    GetEnemyMgr():Reset()
    GetScoreMgr():SetScore(0)
    self.Paused = false
end

function GameMgr:OnDestroy()
end

return GameMgr